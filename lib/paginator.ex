defmodule Paginator do
  import Ecto.Query, warn: false

  @enforce_keys [:current_page_number, :next_page_number, :previous_page_number, :num_pages]
  defstruct [:current_page_number, :next_page_number, :previous_page_number, :num_pages]

  defguard is_positive_integer(number) when is_integer(number) and number >= 1

  @doc """
  Paginate a Ecto.Query by adding offset and limit expression
  """
  def paginate(%Ecto.Query{} = query, page_number, paginate_by)
      when is_positive_integer(page_number) and is_positive_integer(paginate_by) do
    offset_value = (page_number - 1) * paginate_by

    query
    |> offset(^offset_value)
    |> limit(^paginate_by)
  end

  @doc """
  Helper function that makes a struct that can be used in templates

  Example:

    <div>
        <%= if @paginator.previous_page_number do %>
            <a href="?page=1">First</a>
            <a href="?page=<%= @paginator.previous_page_number %>">Previous</a>
        <% end %>

        <span>
            Page <%= @paginator.current_page_number %> of <%= @paginator.num_pages %>.
        </span>

        <%= if @paginator.next_page_number do %>
            <a href="?page=<%= @paginator.next_page_number %>">Next</a>
            <a href="?page=<%= @paginator.num_pages %>">Last</a>
        <% end %>
    </div>
  """
  def paginate_helper(page_number, paginate_by, total)
      when is_positive_integer(page_number) and is_positive_integer(paginate_by) and
             is_positive_integer(total) do
    next_page_number = page_number + 1
    previous_page_number = page_number - 1
    num_pages = div(total, paginate_by)

    %Paginator{
      current_page_number: page_number,
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
