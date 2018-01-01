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

defmodule Lighthouse.Properties do
  @namespace :lighthouse
  @udp_port { :udp_port, 9998 }

  def environment_variable(name), do: String.upcase "#{@namespace}_#{name}"

  def read_property(config, type_converter, environment \\ System.get_env()) do
    {name, default_value} = config
    case Map.get(environment, environment_variable name) do
      nil -> Application.get_env(@namespace, name, default_value)
      val -> type_converter.(val)
    end
  end

  def get_udp_port(), do: read_property @udp_port, &String.to_integer/1
end
