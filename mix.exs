defmodule EctoPaginator.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :ecto_paginator,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
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
      {:ecto, "~> 3.3.4"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{github: "https://github.com/nwjlyons/ecto_paginator"}
    ]
  end

  defp docs do
    [
      main: "EctoPaginator",
      source_ref: "v#{@version}",
      source_url: "https://github.com/nwjlyons/ecto_paginator"
    ]
  end
end
