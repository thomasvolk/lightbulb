defmodule Light do
  use Application

  def start(_type, []) do
    Light.Supervisor.start_link()
  end

  def get_nodes() do
    Light.Registry.get_nodes()
  end

  def subscribe() do
    Light.Registry.subscribe()
  end

  def unsubscribe() do
    Light.Registry.unsubscribe()
  end

end

defmodule Light.IpAddress do
  def to_string(ip), do: Kernel.to_string(:inet.ntoa(ip))
end
