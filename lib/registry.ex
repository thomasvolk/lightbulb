
defmodule Lighthouse.Registry do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: __MODULE__])
  end

  def get_nodes() do
    GenServer.call(__MODULE__, {:get_nodes})
  end

  def subscribe() do
    GenServer.call(__MODULE__, {:subscribe})
  end

  def unsubscribe() do
    GenServer.call(__MODULE__, {:unsubscribe})
  end

  def cleanup() do
    GenServer.cast(__MODULE__, {:cleanup})
  end

  def register_node(ip, data) do
    GenServer.cast(__MODULE__, {:register_node, ip, data})
  end

  def filter_expired(nodes, expiration_interval) do
    nodes |> Enum.filter( fn {_k, {_d, date}} -> DateTime.diff(DateTime.utc_now(), date, :milliseconds) <= expiration_interval end) |> Map.new
  end

  defp to_node_list(nodes) do
    nodes |> Map.to_list |> Enum.map(fn {ip, {data, _time}} -> {ip, data} end ) |> Enum.sort
  end

  defp publish_event(listener, nodes, new_nodes) do
    delta = map_size(nodes) - map_size(new_nodes)
    if delta != 0 do
      listener |> Enum.map(fn pid -> send(pid, {:lighthouse_nodes_updated, to_node_list(new_nodes) }) end)
    end
  end

  def init({node_lifespan}) do
    {:ok, {Map.new, [], node_lifespan} }
  end

  def handle_call({:get_nodes}, _form, {nodes, _listener, _node_lifespan} = state) do
    {:reply, to_node_list(nodes) , state}
  end

  def handle_call({:subscribe}, {pid, _ref}, {nodes, listener, node_lifespan}) do
    new_listener = [ pid | listener ] |> Enum.uniq |> Enum.filter(&Process.alive?/1)
    {:reply, length(new_listener) > length(listener), { nodes, new_listener, node_lifespan } }
  end

  def handle_call({:unsubscribe}, {in_pid, _ref}, {nodes, listener, node_lifespan}) do
    new_listener = listener |> Enum.filter(fn pid -> pid != in_pid end) |> Enum.filter(&Process.alive?/1)
    {:reply, length(new_listener) < length(listener), { nodes, new_listener, node_lifespan } }
  end

  def handle_info(:cleanup, {nodes, listener, node_lifespan}) do
    filtered_nodes = filter_expired(nodes, node_lifespan)
    publish_event(listener, nodes, filtered_nodes)
    {:noreply, { filtered_nodes, listener, node_lifespan } }
  end

  def handle_cast({:register_node, ip, data}, {nodes, listener, node_lifespan}) do
    new_nodes = Map.put(nodes, ip, {data, DateTime.utc_now()})
    Process.send_after(self(), :cleanup, node_lifespan + 10)
    publish_event(listener, nodes, new_nodes)
    {:noreply, { new_nodes, listener, node_lifespan } }
  end
end
