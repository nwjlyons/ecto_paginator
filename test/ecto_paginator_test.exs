defmodule EctoPaginatorTest do
  use ExUnit.Case
  import Ecto.Query, warn: false

  describe "paginate" do
    test "returns Ecto.Query with offset and limit expressions populated" do
      query = EctoPaginator.paginate(from("table_name"), 1, 25)

      assert %Ecto.Query{
               offset: %Ecto.Query.QueryExpr{params: [{0, :integer}]},
               limit: %Ecto.Query.QueryExpr{params: [{25, :integer}]}
             } = query
    end
  end

  describe "paginate_helper" do
    test "before first page" do
      assert_raise FunctionClauseError, fn ->
        EctoPaginator.paginate_helper(-1, 20, 100)
      end
    end

    test "for first page" do
      assert %EctoPaginator{
               current_page_number: 1,
               next_page_number: 2,
               previous_page_number: nil,
               num_pages: 5
             } = EctoPaginator.paginate_helper(1, 20, 100)
    end

    test "for middle page" do
      assert %EctoPaginator{
               current_page_number: 3,
               next_page_number: 4,
               previous_page_number: 2,
               num_pages: 5
             } = EctoPaginator.paginate_helper(3, 20, 100)
    end

    test "for last page" do
      assert %EctoPaginator{
               current_page_number: 5,
               next_page_number: nil,
               previous_page_number: 4,
               num_pages: 5
             } = EctoPaginator.paginate_helper(5, 20, 100)
    end

    test "beyond last page" do
      assert %EctoPaginator{
               current_page_number: 10,
               next_page_number: nil,
               previous_page_number: 9,
               num_pages: 5
             } = EctoPaginator.paginate_helper(10, 20, 100)
    end
  end
end
