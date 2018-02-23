defmodule UdpServerTest do
  use ExUnit.Case
  doctest Light.UdpServer

  setup do
    Light.Registry.purge()
    Light.subscribe()

    on_exit fn ->
     Light.unsubscribe()
   end
  end

  test "the Light.UdpServer should register nodes by receiving an udp event" do
    pid = GenServer.whereis(Light.UdpServer)
    send pid, {:udp, :socket, {1,2,3,4}, 99999, 'test::udp::event'}

    assert_receive {:light_nodes_updated, [ {{1, 2, 3, 4}, "test::udp::event"} ] }
  end

end
