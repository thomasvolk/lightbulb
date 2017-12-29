defmodule Lighthouse.Test.UdpMock do
  @behaviour Lighthouse.Udp

  def broadcast(port, address, socket, payload) do
    Lighthouse.Test.Monitor.send({port, address, socket, payload})
  end

  def listen(_port) do
  end

  def broadcast_connect() do
    :socket
  end
end
