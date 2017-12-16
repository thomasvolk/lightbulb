defmodule Lighthouse do
  use Application

  def start(_type, []) do
    Lighthouse.Supervisor.start_link()
  end
end

defmodule Lighthouse.IpAddress do
  def to_string(ip), do: Kernel.to_string(:inet.ntoa(ip))
end
