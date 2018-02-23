defmodule UdpBroadcastTest do
  use ExUnit.Case
  doctest Light.UdpBroadcast

  setup do
    {:ok, _pid} = start_supervised({Light.Test.Monitor, self()})
    :ok
  end

  test "the Light.UdpBroadcast should send more than one singnal" do
    assert_receive {9998, "255.255.255.255", :socket, "light::node"}
    assert_receive {9998, "255.255.255.255", :socket, "light::node"}
  end

end
