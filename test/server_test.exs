defmodule UdpServerTest do
  use ExUnit.Case
  doctest Lightbulb.UdpServer

  setup do
    Lightbulb.Registry.purge()
    Lightbulb.subscribe()

    on_exit fn ->
     Lightbulb.unsubscribe()
   end
  end

  test "the Lightbulb.UdpServer should register nodes by receiving an udp event" do
    pid = GenServer.whereis(Lightbulb.UdpServer)
    send pid, {:udp, :socket, {1,2,3,4}, 99999, 'test::udp::event'}

    assert_receive {:lightbulb_nodes_updated, [ {{1, 2, 3, 4}, "test::udp::event"} ] }
  end

end
