defmodule Pagination.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Pagination.Repo,
    ]

    opts = [strategy: :one_for_one, name: Pagination.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
