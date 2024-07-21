defmodule Hypa.MixProject do
  use Mix.Project

  def project do
    [
      app: :hypa,
      description: "HTMX utilities for Elixir",
      version: "0.2.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Hypa",
      source_url: "https://github.com/Cantido/hypa",
      docs: [
        main: "Hypa",
        extras: ["README.md"]
      ],

      # Package
      package: [
        licenses: ["AGPL-3.0-or-later"],
        links: %{
          "GitHub" => "https://github.com/Cantido/hypa",
          "Sponsor" => "https://liberapay.com/rosa"
        }
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.7.14", optional: true},
      {:plug, "~> 1.16.1"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end
end
