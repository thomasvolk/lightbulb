defmodule Lighthouse.Ip4UdpServer do
  use GenServer
  require Logger
  @udp Application.get_env(:lighthouse, :udp_api)

  def start_link(port) do
    GenServer.start_link(__MODULE__, {port}, [name: __MODULE__])
  end

  def init({port}) do
    Logger.info "start #{__MODULE__} port=#{port}"
    socket = @udp.listen(port)
    {:ok, {socket, port } }
  end

  def handle_info({:udp, _socket, ip, _port, data}, state) do
    msg = to_string(data)
    Logger.debug "receive message '#{msg}' from #{Lighthouse.IpAddress.to_string(ip)}"
    Lighthouse.Registry.register_node(ip, msg)
    {:noreply, state}
  end

  def handle_info({_, _socket}, state) do
    {:noreply, state}
  end
end

defmodule Lighthouse.Ip4UdpBroadcast do
  use GenServer
  require Logger
  @udp Application.get_env(:lighthouse, :udp_api)

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: __MODULE__])
  end

  def init({port, payload, address, interval}) do
    Logger.info "start #{__MODULE__} port=#{port}"
    socket = @udp.broadcast_connect()
    Process.send_after(self(), :broadcast, interval)
    {:ok, {socket, {port, payload, address, interval} } }
  end

  def handle_info(:broadcast, {socket, {port, payload, address, interval}} = state) do
    Logger.debug "send broadcast to #{address}"
    @udp.broadcast(port, address, socket, payload)
    Process.send_after(self(), :broadcast, interval)
    {:noreply, state}
  end
end
