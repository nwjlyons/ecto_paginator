# Paginator

Pagination library for Ecto

## Usage

### Context

```elixir
defmodule Foo.Accounts do
  import Ecto.Query, warn: false
  alias Foo.Repo

  alias Foo.Accounts.User

  def list_users_with_pagination(page_number, paginate_by) do
    list_users_query()
    |> Paginator.paginate(page_number, paginate_by)
    |> Repo.all()
  end

  def count_users do
    Repo.aggregate(list_users_query(), :count)
  end

  defp list_users_query() do
    from(User)
    |> order_by(asc: :inserted_at)
  end
end
```

### Controller

```elixir
defmodule FooWeb.UserController do
  use FooWeb, :controller

  alias Foo.Accounts
  alias Foo.Repo

  @paginate_by 20

  def index(conn, %{"page" => current_page}) do
    {current_page, _} = Integer.parse(current_page)

    users = Accounts.list_users_with_pagination(current_page, @paginate_by)
    paginator = Paginator.paginate_helper(current_page, @paginate_by, Accounts.count_users())

    render(conn, "index.html", users: users, paginator: paginator)
  end

  def index(conn, _params), do: index(conn, %{"page" => "1"})
end
```

### Template

```html
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
```
