# Hypa

[![Elixir build](https://github.com/Cantido/hypa/actions/workflows/elixir.yml/badge.svg)](https://github.com/Cantido/hypa/actions/workflows/elixir.yml)
![Hex.pm Version](https://img.shields.io/hexpm/v/hypa)
![Hex.pm License](https://img.shields.io/hexpm/l/hypa)
[![hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/hypa/)

Useful functions for Elixir applications using [htmx].

[htmx]: https://htmx.org

## Installation

This library is [available in Hex](https://hex.pm/packages/hypa), and the package can be installed
by adding `hypa` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hypa, "~> 0.1.0"}
  ]
end
```

Documentation can be found at <https://hexdocs.pm/hypa>.

## Usage

Use [`Hypa.Plug`] to add htmx request headers to `conn.assigns`.
Add it to your `Plug` pipeline like this:

```elixir
plug Hypa.Plug
```

See [the docs](https://hexdocs.pm/hypa) for more information.

[`Hypa.Plug`]: https://hexdocs.pm/hypa/Hypa.Plug.html

## License

Copyright © 2024 Rosa Richter

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
