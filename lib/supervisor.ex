defmodule Light.Supervisor do
  use Supervisor
  alias Light.Properties

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  defp server_worker_spec(udp_port) do
    {Light.UdpServer, udp_port}
  end

  defp broadcast_worker_spec(udp_port) do
    broadcast_interval = Properties.broadcast_interval()
    broadcast_message = Properties.broadcast_message()
    broadcast_address = Properties.broadcast_address()

    {Light.UdpBroadcast, {udp_port, broadcast_message, broadcast_address, broadcast_interval}}
  end

  def init(:ok) do
    udp_port = Properties.udp_port()
    node_lifespan = Properties.node_lifespan()

    worker = [ {Light.Registry, {node_lifespan}},
               server_worker_spec(udp_port),
               broadcast_worker_spec(udp_port) ]

    Supervisor.init(worker, strategy: :one_for_one)
  end
end
