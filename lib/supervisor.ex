defmodule Lighthouse.Supervisor do
  use Supervisor

  @udp_port 9998
  @broadcast_interval 5000
  @broadcast_message "lighthouse::node"
  @broadcast_address "255.255.255.255"
  @node_lifespan 30000

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  defp server_worker_spec(udp_port) do
    {Lighthouse.UdpServer, udp_port}
  end

  defp broadcast_worker_spec(udp_port) do
    broadcast_interval = Application.get_env(:lighthouse, :broadcast_interval, @broadcast_interval)
    broadcast_message = Application.get_env(:lighthouse, :broadcast_message, @broadcast_message)
    broadcast_address = Application.get_env(:lighthouse, :broadcast_address, @broadcast_address)

    {Lighthouse.UdpBroadcast, {udp_port, broadcast_message, broadcast_address, broadcast_interval}}
  end

  def init(:ok) do
    udp_port = Application.get_env(:lighthouse, :udp_port, @udp_port)
    node_lifespan = Application.get_env(:lighthouse, :node_lifespan, @node_lifespan)

    worker = [ {Lighthouse.Registry, {node_lifespan}},
               server_worker_spec(udp_port),
               broadcast_worker_spec(udp_port) ]

    Supervisor.init(worker, strategy: :one_for_one)
  end
end
