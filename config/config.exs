use Mix.Config

config :pagination,
  ecto_repos: [Pagination.Repo]

import_config "#{Mix.env()}.exs"
