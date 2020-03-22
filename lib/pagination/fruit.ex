defmodule Pagination.Fruit do
  use Ecto.Schema

  schema "fruit" do
    field(:name, :string)

    timestamps()
  end
end
