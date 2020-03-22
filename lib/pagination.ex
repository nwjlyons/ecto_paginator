defmodule Pagination do
  import Ecto.Query, warn: false

  def paginate(query, page, paginate_by) do
    offset_value = (page - 1) * paginate_by
    query
    |> offset(^offset_value)
    |> limit(^paginate_by)
  end

  def make_paginate_struct_for_template(page, _paginate_by, total) do
    %{
        current_page: page,
        next_page: page + 1,
        total_pages: total,
        previous_page: if previous_page = (page - 1) <= 0 do nil else previous_page end
    }
  end
end
