defmodule Lighthouse.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  defp add_server_worker(worker, udp_port) do
    start_server = Application.get_env(:lighthouse, :server)
    if start_server, do: worker ++ [ {Lighthouse.Ip4UdpServer, udp_port} ], else: worker
  end

  defp add_broadcast_worker(worker, udp_port) do
    do_broadcast = Application.get_env(:lighthouse, :broadcast)
    if do_broadcast do
      interval = Application.get_env(:lighthouse, :broadcast_interval)
      payload = Application.get_env(:lighthouse, :broadcast_message)
      broadcast_address = Application.get_env(:lighthouse, :broadcast_address)
      worker ++ [ {Lighthouse.Ip4UdpBroadcast, {udp_port, payload, broadcast_address, interval}} ]
    else
      worker
    end
  end

  def init(:ok) do
    udp_port = Application.get_env(:lighthouse, :udp_port)
    node_lifespan = Application.get_env(:lighthouse, :node_lifespan)

    worker = [{Lighthouse.Registry, {node_lifespan}} ]
      |> add_server_worker(udp_port)
      |> add_broadcast_worker(udp_port)
    Supervisor.init(worker, strategy: :one_for_one)
  end
end
