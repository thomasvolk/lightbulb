defmodule Lighthouse.UdpServer do
  use GenServer
  require Logger
  @udp Application.get_env(:lighthouse, :udp_api)

  def start_link(port) do
    GenServer.start_link(__MODULE__, {port}, [name: __MODULE__])
  end

  def init({port}) do
    Logger.info "start #{__MODULE__} port=#{port}"
    @udp.listen(port)
    {:ok, {} }
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
