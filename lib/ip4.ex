defmodule Lighthouse.Ip4UdpServer do
  use GenServer
  require Logger

  def start_link(port) do
    GenServer.start_link(__MODULE__, {port}, [name: __MODULE__])
  end

  def init({port}) do
    Logger.info "start #{__MODULE__} port=#{port}"
    {:ok, socket} = :gen_udp.open(port)
    {:ok, {socket, port } }
  end

  def handle_info({:udp, _socket, ip, _port, data}, state) do
     Logger.debug "receive message '#{data}' from #{Lighthouse.IpAddress.to_string(ip)}"
     Lighthouse.Registry.register_node(ip)
    {:noreply, state}
  end

  def handle_info({_, _socket}, state) do
    {:noreply, state}
  end
end

defmodule Lighthouse.Ip4UdpBroadcast do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: __MODULE__])
  end

  def send() do
    GenServer.cast(__MODULE__, :broadcast)
  end

  def init({port, payload, address}) do
    Logger.info "start #{__MODULE__} port=#{port}"
    {:ok, socket} = :gen_udp.open(0, [{:broadcast, true}])
    {:ok, {socket, {port, payload, address} } }
  end

  def handle_cast(:broadcast, {socket, {port, payload, address}} = state) do
    Logger.debug "send broadcast to #{address}"
    :gen_udp.send(socket, to_charlist(address), port, payload)
    {:noreply, state}
  end
end
