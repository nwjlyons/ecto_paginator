defmodule PaginationTest do
  use ExUnit.Case
  import Ecto.Query, warn: false

  defp list_fruits() do
    query =
      from f in Fruit
  end

  describe "paginate" do

    test "returns Ecto.Query with offset and limit statements" do

      # /fruits?page=1

      query = Pagination.paginate(list_fruits, 1, 25, 100)

      assert query.offset == 0
      assert query.limit == 25
    end
  end
end
