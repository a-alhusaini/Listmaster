defmodule Listmaster.ListServer do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:ok, []}
  end

  def add(pid, item) do
    ListmasterWeb.Endpoint.broadcast_from(self(), "room:lobby", "list_item_added", %{
      "item" => item
    })

    GenServer.cast(pid, {:add_item, item})
  end

  def all(pid) do
    GenServer.call(pid, :get_items)
  end

  def handle_cast({:add_item, item}, state) do
    {:noreply, state ++ [item]}
  end

  def handle_call(:get_items, _from, state) do
    {:reply, state, state}
  end
end
