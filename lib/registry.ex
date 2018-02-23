
defmodule Light.Registry do
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

  def register_node(ip, data) do
    GenServer.cast(__MODULE__, {:register_node, ip, data})
  end

  def purge() do
    GenServer.call(__MODULE__, {:purge})
  end

  def filter_expired(nodes, expiration_interval) do
    node_expired = fn {_k, {_d, date}} -> DateTime.diff(DateTime.utc_now(), date, :milliseconds) <= expiration_interval end
    nodes |> Enum.filter( node_expired )
          |> Map.new
  end

  def init({node_lifespan}) do
    Process.send_after(self(), {:remove_expired}, node_lifespan)
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

  def handle_call({:purge}, _from, {_nodes, listener, node_lifespan}) do
    {:reply, :ok, { Map.new, listener, node_lifespan } }
  end

  def handle_info({:remove_expired}, {nodes, listener, node_lifespan}) do
    filtered_nodes = filter_expired(nodes, node_lifespan)
    publish_event(listener, nodes, filtered_nodes)
    Process.send_after(self(), {:remove_expired}, node_lifespan)
    {:noreply, { filtered_nodes, listener, node_lifespan } }
  end

  def handle_cast({:register_node, ip, data}, {nodes, listener, node_lifespan}) do
    new_nodes = Map.put(nodes, ip, {data, DateTime.utc_now()})
    publish_event(listener, nodes, new_nodes)
    {:noreply, { new_nodes, listener, node_lifespan } }
  end

  defp publish_event(listener, nodes, new_nodes) do
    delta = map_size(nodes) - map_size(new_nodes)
    if delta != 0 do
      listener |> Enum.map(fn pid -> send(pid, {:light_nodes_updated, to_node_list(new_nodes) }) end)
    end
  end

  defp to_node_list(nodes) do
    nodes |> Map.to_list |> Enum.map(fn {ip, {data, _time}} -> {ip, data} end ) |> Enum.sort
  end

end
