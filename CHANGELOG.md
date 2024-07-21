# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2024-07-21

### Added

- Two new operations to `Hypa.Plug`:
  - `add_htmx_cache_control/2` - adds `hx-request` to the `vary` header for better cache control
  - `put_htmx_layout/2` - removes the Phoenix layouts from responses to htmx requests.
    This is only enabled if `Phoenix.Controller` is defined.
    Phoenix is now an optional dependency.

## [0.1.0] - 2024-07-18

### Added

- `Hypa.Plug` - parses htmx request headers and puts them in `conn.assigns`

[0.2.0]: https://github.com/Cantido/hypa/releases/tag/v0.2.0
[0.1.0]: https://github.com/Cantido/hypa/releases/tag/v0.1.0
