defmodule Listmaster.ListIdMapServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: :list_map)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def add_list_pid_link(pid, id) do
    ListmasterWeb.Endpoint.broadcast_from(
      self(),
      "room:lobby",
      "new_list",
      %{}
    )

    GenServer.cast(pid, {:add_list_id, id})
  end

  def get_list_pid(pid, id) do
    GenServer.call(pid, {:get_list_pid, id})
  end

  def handle_call({:get_list_pid, id}, _from, state) do
    reply =
      case Map.fetch(state, id) do
        {:ok, value} -> value
        :error -> nil
      end

    {:reply, reply, state}
  end

  def handle_cast({:add_list_id, id}, state) do
    {:ok, pid} = Listmaster.ListServer.start_link()
    {:noreply, Map.merge(state, %{id => pid})}
  end
end
