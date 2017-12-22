
defmodule Lighthouse.Registry do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: __MODULE__])
  end

  def get_nodes(expiration_interval \\ 30000) do
    GenServer.call(__MODULE__, {:get_nodes, expiration_interval})
  end

  def listen() do
    GenServer.call(__MODULE__, {:listen_to})
  end

  def register_node(ip) do
    GenServer.cast(__MODULE__, {:register_node, ip})
  end

  def init(state) do
    {:ok, {state, []} }
  end

  def filter_expired(nodes, expiration_interval) do
    nodes |> Enum.filter( fn {_k, v} -> DateTime.diff(DateTime.utc_now(), v, :milliseconds) <= expiration_interval end) |> Map.new
  end

  def handle_call({:get_nodes, expiration_interval}, _form, {nodes, _listener} = state) do
    filtered_nodes = filter_expired(nodes, expiration_interval)
    {:reply, filtered_nodes, state}
  end

  def handle_call({:listen_to}, {pid, _ref}, {nodes, listener}) do
    new_listener = [ pid | listener ] |> Enum.uniq |> Enum.filter(&Process.alive?/1)
    {:reply, :ok, { nodes, new_listener } }
  end

  def handle_cast({:register_node, ip}, {nodes, listener}) do
    new_nodes = Map.put(nodes, ip, DateTime.utc_now())
    listener |> Enum.map(fn pid ->  send(pid, {:update, new_nodes}) end)
    {:noreply, { new_nodes, listener } }
  end
end
