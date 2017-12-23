defmodule Lighthouse.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  defp add_server_worker(worker, udp_port) do
    start_server = Application.get_env(:lighthouse, :server, true)
    if start_server, do: worker ++ [ {Lighthouse.Ip4UdpServer, udp_port} ], else: worker
  end

  defp add_broadcast_worker(worker, udp_port) do
    do_broadcast = Application.get_env(:lighthouse, :broadcast, true)
    if do_broadcast do
      interval = Application.get_env(:lighthouse, :interval, 10000)
      worker ++ [
        {Lighthouse.Ip4UdpBroadcast, udp_port},
        {Lighthouse.Scheduler, {interval, &Lighthouse.Ip4UdpBroadcast.send/0}} ]
    else
      worker
    end
  end

  def init(:ok) do
    udp_port = Application.get_env(:lighthouse, :udp_port, 9998)
    node_expiration_interval = Application.get_env(:lighthouse, :node_expiration_interval, 30000)
    registry_cleanup_interval = Application.get_env(:lighthouse, :registry_cleanup_interval, 2000)

    worker = [{Lighthouse.Registry, {node_expiration_interval, registry_cleanup_interval}} ]
      |> add_server_worker(udp_port)
      |> add_broadcast_worker(udp_port)
    Supervisor.init(worker, strategy: :one_for_one)
  end
end
