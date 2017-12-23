
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

  def register_node(ip) do
    GenServer.cast(__MODULE__, {:register_node, ip})
  end

  def init({node_expiration_interval, registry_cleanup_interval}) do
    Process.send_after(self(), :cleanup, registry_cleanup_interval)
    {:ok, {Map.new, node_expiration_interval, registry_cleanup_interval, []} }
  end

  def filter_expired(nodes, expiration_interval) do
    nodes |> Enum.filter( fn {_k, v} -> DateTime.diff(DateTime.utc_now(), v, :milliseconds) <= expiration_interval end) |> Map.new
  end

  defp publish_event(listener, nodes, new_nodes) do
    delta = map_size(nodes) - map_size(new_nodes)
    if delta != 0 do
      listener |> Enum.map(fn pid -> send(pid, {:updated, new_nodes}) end)
    end
  end

  def handle_call({:get_nodes}, _form, {nodes, _node_expiration_interval, _registry_cleanup_interval, _listener} = state) do
    {:reply, nodes, state}
  end

  def handle_call({:subscribe}, {pid, _ref}, {nodes, node_expiration_interval, registry_cleanup_interval, listener}) do
    new_listener = [ pid | listener ] |> Enum.uniq |> Enum.filter(&Process.alive?/1)
    {:reply, length(new_listener) > length(listener), { nodes, node_expiration_interval, registry_cleanup_interval, new_listener } }
  end

  def handle_call({:unsubscribe}, {in_pid, _ref}, {nodes, node_expiration_interval, registry_cleanup_interval, listener}) do
    new_listener = listener |> Enum.filter(fn pid -> pid != in_pid end) |> Enum.filter(&Process.alive?/1)
    {:reply, length(new_listener) < length(listener), { nodes, node_expiration_interval, registry_cleanup_interval, new_listener } }
  end

  def handle_info(:cleanup,{nodes, node_expiration_interval, registry_cleanup_interval, listener} = state) do
    filtered_nodes = filter_expired(nodes, node_expiration_interval)
    publish_event(listener, nodes, filtered_nodes)
    Process.send_after(self(), :cleanup, registry_cleanup_interval)
    {:noreply, state }
  end

  def handle_cast({:register_node, ip}, {nodes, node_expiration_interval, registry_cleanup_interval, listener}) do
    new_nodes = Map.put(nodes, ip, DateTime.utc_now())
    publish_event(listener, nodes, new_nodes)
    {:noreply, { new_nodes, node_expiration_interval, registry_cleanup_interval, listener } }
  end
end
