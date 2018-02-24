defmodule Lightbulb.Udp do
  @callback broadcast(number, String.t, port, String.t) :: nil
  @callback listen(port) :: nil
  @callback broadcast_connect() :: port
end

defmodule Lightbulb.UdpIpv4 do
  @behaviour Lightbulb.Udp

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

defmodule Lightbulb.UdpIpv6 do
  @behaviour Lightbulb.Udp

  def broadcast(port, address, socket, payload) do
    Lightbulb.UdpIpv4.broadcast(port, address, socket, payload)
  end

  def listen(port) do
    {:ok, _socket} = :gen_udp.open(port, [:inet6])
  end

  def broadcast_connect() do
    {:ok, socket} = :gen_udp.open(0, [:inet6])
    socket
  end
end
