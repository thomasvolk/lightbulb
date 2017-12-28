defmodule UdpBroadcastTest do
  use ExUnit.Case
  doctest Lighthouse.UdpBroadcast

  setup do
    {:ok, _pid} = start_supervised({Lighthouse.Test.Monitor, self()})
    :ok
  end

  test "the Lighthouse.UdpBroadcast should send more than one singnal" do
    assert_receive {9998, "255.255.255.255", :socket, "lighthouse::node"}
    assert_receive {9998, "255.255.255.255", :socket, "lighthouse::node"}
  end

end
