defmodule Lighthouse.UdpBroadcast do
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
