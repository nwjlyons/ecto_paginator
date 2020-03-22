defmodule Paginator.Test.Fruit do
  use Ecto.Schema

  schema "fruit" do
    field(:name, :string)

    timestamps()
  end
end


defmodule PaginatorTest do
  use ExUnit.Case
  import Ecto.Query, warn: false
  alias Paginator.Test.Fruit

  describe "new" do
    test "returns Ecto.Query with offset and limit and Paginator struct" do
      {query, paginator} = Paginator.new(from(f in Fruit), 1, 25, 100)

      assert %Ecto.Query.QueryExpr{params: [{0, :integer}]} = query.offset
      assert %Ecto.Query.QueryExpr{params: [{25, :integer}]} = query.limit

      assert %Paginator{
        current_page_number: 1,
        next_page_number: 2,
        previous_page_number: nil,
        num_pages: 4,
      } = paginator
    end
  end
end
