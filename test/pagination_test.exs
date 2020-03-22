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

    test "returns Ecto.Query with offset and limit statements for page 5" do
      paginate_by = 20
      query = Pagination.paginate(list_fruits(), 5, paginate_by)
      assert %Ecto.Query.QueryExpr{params: [{80, :integer}]} = query.offset
      assert %Ecto.Query.QueryExpr{params: [{paginate_by, :integer}]} = query.limit
    end
  end

  describe "make_paginate_struct_for_template" do
    test "returns struct" do
      assert %{
          current_page: 1,
          next_page: 2,
          total_pages: 166,
          previous_page: nil
        } = Pagination.make_paginate_struct_for_template(1, 25, 166)
    end
  end
end
