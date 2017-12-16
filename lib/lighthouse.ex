defmodule Lighthouse do
  use Application

  def start(_type, {port, interval}) do
    Lighthouse.Supervisor.start_link({port, interval})
  end
end

defmodule Lighthouse.IpAddress do
  def to_string(ip), do: Kernel.to_string(:inet.ntoa(ip))
end
