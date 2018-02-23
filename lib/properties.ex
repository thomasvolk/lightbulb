defmodule Light.Properties do
  @namespace :light
  @udp_port { :udp_port, 9998 }
  @broadcast_address { :broadcast_address, "255.255.255.255" }
  @broadcast_message { :broadcast_message, "light::node" }
  @broadcast_interval { :broadcast_interval, 5000 }
  @node_lifespan { :node_lifespan, 30000 }
  @udp_api { :udp_api, Light.UdpIpv4 }

  def to_module(str) do
    mod_name = if String.starts_with?(str, "Elixir"), do: str, else: "Elixir.#{str}"
    String.to_existing_atom mod_name
  end

  def environment_variable(name), do: String.upcase "#{@namespace}_#{name}"

  def read_property(config, type_converter \\ fn v -> v end, environment \\ System.get_env()) do
    {name, default_value} = config
    case Map.get(environment, environment_variable name) do
      nil -> Application.get_env(@namespace, name, default_value)
      val -> type_converter.(val)
    end
  end

  def udp_port(), do: read_property @udp_port, &String.to_integer/1
  def broadcast_address(), do: read_property @broadcast_address
  def broadcast_message(), do: read_property @broadcast_message
  def broadcast_interval(), do: read_property @broadcast_interval, &String.to_integer/1
  def node_lifespan(), do: read_property @node_lifespan, &String.to_integer/1
  def udp_api(), do: read_property @udp_api, &to_module/1
end
