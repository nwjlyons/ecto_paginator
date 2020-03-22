defmodule EctoPaginator.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_paginator,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/nwjlyons/ecto_paginator",
      description:
        "Pagination library for Ecto. Includes helper for building 'next' and 'previous' links in a template."
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.3.4"}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{github: "https://github.com/nwjlyons/ecto_paginator"},
    ]
  end
end
