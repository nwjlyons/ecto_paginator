defmodule EctoPaginator do
  @moduledoc """
  Pagination library for Ecto

  ## Usage

  ### Context

      defmodule Foo.Accounts do
        import Ecto.Query, warn: false
        alias Foo.Repo

        alias Foo.Accounts.User

        def list_users_with_pagination(page_number, paginate_by) do
          list_users_query()
          |> EctoPaginator.paginate(page_number, paginate_by)
          |> Repo.all()
        end

        def count_users() do
          Repo.aggregate(list_users_query(), :count)
        end

        defp list_users_query() do
          from(User)
          |> order_by(asc: :inserted_at)
        end
      end

  ### Controller

      defmodule FooWeb.UserController do
        use FooWeb, :controller

        alias Foo.Accounts
        alias Foo.Repo

        @paginate_by 20

        def index(conn, %{"page" => current_page}) do
          {current_page, _} = Integer.parse(current_page)

          users = Accounts.list_users_with_pagination(current_page, @paginate_by)
          paginator = EctoPaginator.paginate_helper(current_page, @paginate_by, Accounts.count_users())

          render(conn, "index.html", users: users, paginator: paginator)
        end

        def index(conn, _params), do: index(conn, %{"page" => "1"})
      end

  ### Template

      <%= if @paginator.previous_page_number do %>
        <a href="?page=1">First</a>
        <a href="?page=<%= @paginator.previous_page_number %>">Previous</a>
      <% end %>

      Page <%= @paginator.current_page_number %> of <%= @paginator.num_pages %>.

      <%= if @paginator.next_page_number do %>
        <a href="?page=<%= @paginator.next_page_number %>">Next</a>
        <a href="?page=<%= @paginator.num_pages %>">Last</a>
      <% end %>
  """
  import Ecto.Query, warn: false

  @enforce_keys [:current_page_number, :next_page_number, :previous_page_number, :num_pages]
  defstruct [:current_page_number, :next_page_number, :previous_page_number, :num_pages]

  @type t :: %__MODULE__{
          current_page_number: pos_integer(),
          next_page_number: pos_integer() | nil,
          previous_page_number: pos_integer() | nil,
          num_pages: pos_integer()
        }

  @doc """
  Paginate an `Ecto.Query` by adding `Ecto.Query.offset/3` and `Ecto.Query.limit/3` expressions.

  ## Examples

      iex> from("table_name") |> EctoPaginator.paginate(4, 20)
      #Ecto.Query<from t0 in "table_name", limit: ^20, offset: ^60>

  """
  @spec paginate(Ecto.Query.t(), pos_integer(), pos_integer()) :: Ecto.Query.t()
  def paginate(%Ecto.Query{} = query, page_number, paginate_by)
      when page_number > 0 and paginate_by > 0 do
    offset_value = (page_number - 1) * paginate_by

    query
    |> offset(^offset_value)
    |> limit(^paginate_by)
  end

  @doc """
  Helper function that makes a struct that can be used for building "next" and "previous" links in templates.

  ## Examples

      iex> EctoPaginator.paginate_helper(4, 20, 500)
      %EctoPaginator{
        current_page_number: 4,
        next_page_number: 5,
        num_pages: 25,
        previous_page_number: 3
      }

  ## Use in Templates

      <%= if @paginator.previous_page_number do %>
          <a href="?page=1">First</a>
          <a href="?page=<%= @paginator.previous_page_number %>">Previous</a>
      <% end %>

      Page <%= @paginator.current_page_number %> of <%= @paginator.num_pages %>.

      <%= if @paginator.next_page_number do %>
          <a href="?page=<%= @paginator.next_page_number %>">Next</a>
          <a href="?page=<%= @paginator.num_pages %>">Last</a>
      <% end %>
  """
  @spec paginate_helper(pos_integer(), pos_integer(), pos_integer()) :: __MODULE__.t()
  def paginate_helper(page_number, paginate_by, total)
      when page_number > 0 and paginate_by > 0 and total > 0 do
    num_pages = div(total, paginate_by)

    %__MODULE__{
      current_page_number: page_number,
      next_page_number: next_page_number(page_number + 1, num_pages),
      previous_page_number: previous_page_number(page_number - 1),
      num_pages: num_pages
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
