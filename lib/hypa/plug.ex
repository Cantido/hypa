defmodule Hypa.Plug do
  @moduledoc """
  A `Plug` offering functions useful for applications using HTMX.

  If you are using Phoenix, add this Plug to your browser pipeline:

      pipeline :browser do
        plug Hypa.Plug
      end

  """

  use Plug.Builder

  plug :detect_htmx_request

  @doc """
  Extracts HTMX headers into the conn's assigns.

  See [Request Headers Reference] for documentation on HTMX's header values.

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

  If the request does not have HTMX headers, the `:htmx` assign will not be present.

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
end
