defmodule Paginator do
  import Ecto.Query, warn: false

  @enforce_keys [:current_page_number, :next_page_number, :previous_page_number, :num_pages]
  defstruct [:current_page_number, :next_page_number, :previous_page_number, :num_pages]

  def new(%Ecto.Query{} = query, current_page_number, paginate_by, total) do
    {make_query(query, current_page_number, paginate_by),
     make_paginator(current_page_number, paginate_by, total)}
  end

  defp make_query(query, current_page_number, paginate_by) do
    offset_value = (current_page_number - 1) * paginate_by

    query
    |> offset(^offset_value)
    |> limit(^paginate_by)
  end

  defp make_paginator(current_page_number, paginate_by, total) do
    next_page_number = current_page_number + 1
    previous_page_number = current_page_number - 1
    num_pages = div(total, paginate_by)

    %Paginator{
      current_page_number: current_page_number,
      next_page_number: next_page_number(next_page_number, num_pages),
      previous_page_number: previous_page_number(previous_page_number),
      num_pages: div(total, paginate_by)
    }
  end

  defp next_page_number(next_page_number, num_pages) do
    if next_page_number <= num_pages do
      next_page_number
    else
      nil
    end
  end

  defp previous_page_number(previous_page_number) do
    if previous_page_number <= 0 do
      nil
    else
      previous_page_number
    end
  end
end
