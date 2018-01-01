defmodule LighthouseTest do
  use ExUnit.Case
  doctest Lighthouse

  test "Lighthouse.IpAddress.to_string should format ipv4 addresses" do
    assert Lighthouse.IpAddress.to_string({10, 1, 0, 23}) == "10.1.0.23"
  end

  test "Lighthouse.IpAddress.to_string should format ipv6 addresses" do
    assert Lighthouse.IpAddress.to_string({65152, 0, 0, 0, 514, 46079, 65054, 33577}) == "fe80::202:b3ff:fe1e:8329"
  end

  test "Lighthouse.Properties should read properties from a map or return default values" do
    assert Lighthouse.Properties.environment_variable :test_X_1 == "LIGHTHOUSE_TEST_X_1"
    assert Lighthouse.Properties.read_property({ :test_var, 1111 }, %{}) == 1111
    assert Lighthouse.Properties.read_property({ :test_var, 1111 }, &String.to_integer/1, %{"LIGHTHOUSE_TEST_VAR" => "2222"}) == 2222
  end

  test "Lighthouse.Properties should read properties from a map or from the application environment" do
    assert Lighthouse.Properties.read_property({ :udp_port, 1111 }, %{}) == 9998
  end
end
