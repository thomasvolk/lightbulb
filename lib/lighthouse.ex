defmodule Lighthouse do
  use Application

  @udp_api Lighthouse.UdpIpv4
  def udp_api(), do: @udp_api

  def start(_type, []) do
    Lighthouse.Supervisor.start_link()
  end

  def get_nodes() do
    Lighthouse.Registry.get_nodes()
  end

  def subscribe() do
    Lighthouse.Registry.subscribe()
  end

  def unsubscribe() do
    Lighthouse.Registry.unsubscribe()
  end

end

defmodule Lighthouse.IpAddress do
  def to_string(ip), do: Kernel.to_string(:inet.ntoa(ip))
end
