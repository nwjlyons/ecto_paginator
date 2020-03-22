defmodule Pagination do
  import Ecto.Query, warn: false

  def paginate(query, page, paginate_by) do
    offset_value = (page - 1) * paginate_by
    query
    |> offset(^offset_value)
    |> limit(^paginate_by)
  end
end
