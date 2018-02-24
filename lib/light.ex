defmodule Lightbulb do
  use Application

  def start(_type, []) do
    Lightbulb.Supervisor.start_link()
  end

  def get_nodes() do
    Lightbulb.Registry.get_nodes()
  end

  def subscribe() do
    Lightbulb.Registry.subscribe()
  end

  def unsubscribe() do
    Lightbulb.Registry.unsubscribe()
  end

end

defmodule Lightbulb.IpAddress do
  def to_string(ip), do: Kernel.to_string(:inet.ntoa(ip))
end
