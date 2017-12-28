defmodule Lighthouse.Test.UdpMock do
  def broadcast(_port, _address, _socket, _payload) do
  end

  def listen(_port) do
  end

  def broadcast_connect() do
    'socket'
  end
end
