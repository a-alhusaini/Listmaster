defmodule ListmasterWeb.ListLive do
  use ListmasterWeb, :live_view

  def mount(_params, _something, socket) do
    socket = assign(socket, items: [], list_count: 0, connected: connected?(socket))

    if connected?(socket) do
      ListmasterWeb.Endpoint.subscribe("room:lobby")
    end

    socket =
      assign(socket,
        items: Map.keys(Listmaster.ListIdMapServer.get_all_lists(:list_map))
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>
      Is connected: <%= @connected %>
    </h1>
    <h1>
      lists: <%= @list_count %>
    </h1>
    <h1>
      The lists are:
      <%= for item <- @items do %>
        <%= item %>,
      <% end %>
    </h1>
    """
  end

  def handle_info(%{event: "list_item_added", payload: %{"item" => item}}, socket) do
    current_list_count = socket.assigns.list_count

    {:noreply,
     assign(socket, items: socket.assigns.items ++ [item], list_count: current_list_count + 1)}
  end
end
