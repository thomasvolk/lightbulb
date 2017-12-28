defmodule Lighthouse.Udp do
  def broadcast(port, address, socket, payload) do
    :gen_udp.send(socket, to_charlist(address), port, payload)
  end

  def listen(port) do
    {:ok, _socket} = :gen_udp.open(port)
  end

  def broadcast_connect() do
    {:ok, socket} = :gen_udp.open(0, [{:broadcast, true}])
    socket
  end
end