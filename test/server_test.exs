defmodule UdpServerTest do
  use ExUnit.Case
  doctest Lighthouse.UdpServer

  setup do
    Lighthouse.Registry.purge()
    Lighthouse.subscribe()

    on_exit fn ->
     Lighthouse.unsubscribe()
   end
  end

  test "the Lighthouse.UdpServer should register nodes by receiving an udp event" do
    pid = GenServer.whereis(Lighthouse.UdpServer)
    send pid, {:udp, :socket, {1,2,3,4}, 99999, 'test::udp::event'}

    assert_receive {:lighthouse_nodes_updated, [ {{1, 2, 3, 4}, "test::udp::event"} ] }
  end

end
