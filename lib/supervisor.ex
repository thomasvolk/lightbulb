defmodule Lighthouse.Supervisor do
  use Supervisor

  def start_link({udp_port, interval}) do
    Supervisor.start_link(__MODULE__, {udp_port, interval}, name: __MODULE__)
  end

  def init({udp_port, interval}) do
    worker = [{Lighthouse.Registry, Map.new}]
    worker = case Application.get_env(:lighthouse, :server) do
      true ->
        worker ++ [ {Lighthouse.Ip4UdpServer, udp_port} ]
      _ ->
        worker
    end
    worker = case Application.get_env(:lighthouse, :broadcast) do
      true ->
        worker ++ [
          {Lighthouse.Ip4UdpBroadcast, udp_port},
          {Lighthouse.Scheduler, {interval, &Lighthouse.Ip4UdpBroadcast.send/0}} ]
      _ ->
        worker
    end
    Supervisor.init(worker, strategy: :one_for_one)
  end
end
