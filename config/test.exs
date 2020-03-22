use Mix.Config

# Configure your database
config :pagination, Pagination.Repo,
  username: "nwjlyons",
  password: "postgres",
  database: "pagination_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
