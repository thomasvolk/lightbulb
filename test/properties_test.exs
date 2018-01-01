defmodule PropertiesTest do
  use ExUnit.Case
  doctest Lighthouse.Properties

  alias Lighthouse.Properties

  test "Lighthouse.Properties.environment_variable should generate a env variable name from property" do
    assert Properties.environment_variable :test_X_1 == "LIGHTHOUSE_TEST_X_1"
  end

  test "Lighthouse.Properties.to_module should transfrom a string to a module atom" do
    assert Properties.to_module("System") == System
    assert Properties.to_module("Elixir.Kernel") == Kernel
  end

  test "Lighthouse.Properties should read properties from a map or return default values" do
    assert Properties.read_property({ :test_var, 1111 }, %{}) == 1111
    assert Properties.read_property({ :test_var, 1111 }, &String.to_integer/1, %{"LIGHTHOUSE_TEST_VAR" => "2222"}) == 2222
  end

  test "Lighthouse.Properties should read properties from a map or from the application environment" do
    assert Properties.read_property({ :udp_port, 1111 }, %{}) == 9998
  end

  test "Lighthouse.Properties should return default values" do
    assert Properties.udp_port() == 9998
    assert Properties.udp_api() == Lighthouse.Test.UdpMock
    assert Properties.broadcast_address() == "255.255.255.255"
    assert Properties.broadcast_message() == "lighthouse::node"
    assert Properties.broadcast_interval() == 10
  end
end
