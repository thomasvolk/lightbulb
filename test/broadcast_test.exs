defmodule UdpBroadcastTest do
  use ExUnit.Case
  doctest Lightbulb.UdpBroadcast

  setup do
    {:ok, _pid} = start_supervised({Lightbulb.Test.Monitor, self()})
    :ok
  end

  test "the Lightbulb.UdpBroadcast should send more than one singnal" do
    assert_receive {9998, "255.255.255.255", :socket, "lightbulb::node"}
    assert_receive {9998, "255.255.255.255", :socket, "lightbulb::node"}
  end

end
