defmodule PaginationTest do
  use ExUnit.Case
  import Ecto.Query, warn: false
  alias Pagination.Fruit

  defp list_fruits() do
    from(f in Fruit)
  end

  describe "paginate" do
    test "returns Ecto.Query with offset and limit statements" do
      paginate_by = 25
      query = Pagination.paginate(list_fruits(), 1, paginate_by)
      assert %Ecto.Query.QueryExpr{params: [{0, :integer}]} = query.offset
      assert %Ecto.Query.QueryExpr{params: [{paginate_by, :integer}]} = query.limit
    end
  end
end
