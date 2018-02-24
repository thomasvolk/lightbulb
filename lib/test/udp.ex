defmodule Lightbulb.Test.UdpMock do
  @behaviour Lightbulb.Udp

  def broadcast(port, address, socket, payload) do
    Lightbulb.Test.Monitor.send({port, address, socket, payload})
  end

  def listen(_port) do
  end

  def broadcast_connect() do
    :socket
  end
end
