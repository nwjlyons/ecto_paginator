defmodule Paginator do
  import Ecto.Query, warn: false

  @enforce_keys [:current_page_number, :next_page_number, :previous_page_number, :num_pages]
  defstruct [:current_page_number, :next_page_number, :previous_page_number, :num_pages]

  def new(%Ecto.Query{} = query, current_page_number, paginate_by, total) when current_page_number >= 1 do

    offset_value = (current_page_number - 1) * paginate_by

    query =
      query
      |> offset(^offset_value)
      |> limit(^paginate_by)

    paginator = %Paginator{
        current_page_number: current_page_number,
        next_page_number: current_page_number + 1,
        num_pages: div(total,  paginate_by),
        previous_page_number: if previous_page = (current_page_number - 1) <= 0 do nil else previous_page end
    }

    {query, paginator}
  end
end
