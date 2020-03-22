defmodule Pagination.Repo do
  use Ecto.Repo,
    otp_app: :pagination,
    adapter: Ecto.Adapters.Postgres
end
