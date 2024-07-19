defmodule Hypa.Plug do
  @moduledoc """
  A `Plug` offering functions useful for applications using HTMX.

  This plug invokes the following function plugs:

  - `detect_htmx_request/2` - Adds a `:htmx` map to `conn.assigns` containing htmx request headers.
  - `add_htmx_cache_control/2` - Adds `hx-request` to the response's `vary` header

  The following functions are also invoked if `Phoenix.Controller` is present at compile-time:

  - `put_htmx_layout/2` - Disables the root and app layouts if responding to an htmx request
  """

  use Plug.Builder

  plug :detect_htmx_request
  plug :add_htmx_cache_control

  if Code.ensure_loaded?(Phoenix.Controller) do
    plug :put_htmx_layout
  end

  @doc """
  Extracts HTMX headers into the conn's assigns.

  See [Request Headers Reference] for documentation on htmx's header values.

  [Request Headers Reference]: https://htmx.org/reference/#request_headers

  ## Examples

      iex> conn(:get, "/hello")
      ...> |> merge_req_headers([
      ...>      {"hx-request", "true"},
      ...>      {"hx-current-url", "/current"},
      ...>      {"hx-history-restore-request", "false"},
      ...>      {"hx-target", "my-target-element-id"},
      ...>      {"hx-trigger-name", "my-triggered-element-name"},
      ...>      {"hx-trigger", "my-triggered-element-id"}
      ...>    ])
      ...> |> Hypa.Plug.detect_htmx_request(Hypa.Plug.init([]))
      ...> |> Map.get(:assigns)
      ...> |> Map.get(:htmx)
      %{
        request: true,
        boosted: false,
        current_url: "/current",
        history_restore_request: false,
        prompt: nil,
        target: "my-target-element-id",
        trigger: "my-triggered-element-id",
        trigger_name: "my-triggered-element-name"
      }

  If the request does not have htmx headers, the `:htmx` assign will not be present.

      iex> conn(:get, "/htmxless")
      ...> |> Hypa.Plug.detect_htmx_request(Hypa.Plug.init([]))
      ...> |> Map.get(:assigns)
      ...> |> Map.has_key?(:htmx)
      false
  """
  def detect_htmx_request(conn, _opts) do
    if get_req_header(conn, "hx-request") == ["true"] do
      conn = assign(conn, :htmx, %{
        request: true,
        boosted: get_req_header(conn, "hx-boosted") != [],
        current_url: List.first(get_req_header(conn, "hx-current-url")),
        history_restore_request: get_req_header(conn, "hx-history-restore-request") == ["true"],
        prompt: List.first(get_req_header(conn, "hx-prompt")),
        target: List.first(get_req_header(conn, "hx-target")),
        trigger_name: List.first(get_req_header(conn, "hx-trigger-name")),
        trigger: List.first(get_req_header(conn, "hx-trigger"))
      })

      conn
    else
      conn
    end
  end

  @doc """
  Adds htmx to the response's cache headers in order for caching to work correctly.

  ## Examples

      iex> conn(:get, "/hello")
      ...> |> Hypa.Plug.add_htmx_cache_control(Hypa.Plug.init([]))
      ...> |> get_resp_header("vary")
      ["hx-request"]
  """
  def add_htmx_cache_control(conn, _opts) do
    prepend_resp_headers(conn, [{"vary", "hx-request"}])
  end

  if Code.ensure_loaded?(Phoenix.Controller) do
    @doc """
    Disable Phoenix layouts in responses to htmx requests.

    Only available when Phoenix is available.

    ## Examples

    The root layout (usually containing `<head>` content) is disabled for all htmx requests.

        iex> conn(:get, "/hello")
        ...> |> assign(:htmx, %{request: true})
        ...> |> Hypa.Plug.put_htmx_layout(Hypa.Plug.init([]))
        ...> |> Phoenix.Controller.root_layout("html")
        false

    Usually, the app layout is disabled for htmx requests as well.

        iex> conn(:get, "/hello")
        ...> |> assign(:htmx, %{request: true})
        ...> |> Hypa.Plug.put_htmx_layout(Hypa.Plug.init([]))
        ...> |> Phoenix.Controller.layout("html")
        false

    However, requests made using `hx-boost` are given the app layout.
    The root layout is still disabled for boosted requests.

        iex> conn(:get, "/hello")
        ...> |> Phoenix.Controller.put_layout(html: {MyApp.Layouts, :app})
        ...> |> assign(:htmx, %{request: true, boosted: true})
        ...> |> Hypa.Plug.put_htmx_layout(Hypa.Plug.init([]))
        ...> |> Phoenix.Controller.layout("html")
        {MyApp.Layouts, :app}

    This is also the case for history restore requests.
    The root layout is disabled for history restore requests as well.

        iex> conn(:get, "/hello")
        ...> |> Phoenix.Controller.put_layout(html: {MyApp.Layouts, :app})
        ...> |> assign(:htmx, %{request: true, history_restore_request: true})
        ...> |> Hypa.Plug.put_htmx_layout(Hypa.Plug.init([]))
        ...> |> Phoenix.Controller.layout("html")
        {MyApp.Layouts, :app}
    """
    def put_htmx_layout(conn, _opts) do
      if get_in(conn.assigns, [:htmx, :request]) do
        conn = Phoenix.Controller.put_root_layout(conn, html: false)

        if conn.assigns.htmx[:boosted] || conn.assigns.htmx[:history_restore_request] do
          conn
        else
          Phoenix.Controller.put_layout(conn, html: false)
        end
      else
        conn
      end
    end
  end
end
