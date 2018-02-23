defmodule Light.Test.UdpMock do
  @behaviour Light.Udp

  def broadcast(port, address, socket, payload) do
    Light.Test.Monitor.send({port, address, socket, payload})
  end

  def listen(_port) do
  end

  def broadcast_connect() do
    :socket
  end
end
