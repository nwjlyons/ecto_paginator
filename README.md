# Paginator

## Usage

```elixir
def index(conn, %{"page" => current_page}) do
    {current_page, _} = Integer.parse(current_page)
    page_count = Journal.count_page()
    {query, paginator} = Paginator.new(Journal.list_page_query(), current_page, 5, page_count)
    page = Repo.all(query)
    render(conn, "index.html", page: page, paginator: paginator)
end

def index(conn, _params) do
    index(conn, %{"page" => "1"})
end
```


```html
<div>
    <span>
        <%= if @paginator.previous_page_number do %>
            <a href="?page=1">&laquo; first</a>
            <a href="?page=<%= @paginator.previous_page_number %>">previous</a>
        <% end %>

        <span>
            Page <%= @paginator.current_page_number %> of <%= @paginator.num_pages %>.
        </span>

        <%= if @paginator.next_page_number do %>
            <a href="?page=<%= @paginator.next_page_number %>">next</a>
            <a href="?page=<%= @paginator.num_pages %>">last &raquo;</a>
        <% end %>
    </span>
</div>
```
