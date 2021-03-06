defmodule LightbulbTest do
  use ExUnit.Case
  doctest Lightbulb

  test "Lightbulb.IpAddress.to_string should format ipv4 addresses" do
    assert Lightbulb.IpAddress.to_string({10, 1, 0, 23}) == "10.1.0.23"
  end

  test "Lightbulb.IpAddress.to_string should format ipv6 addresses" do
    assert Lightbulb.IpAddress.to_string({65152, 0, 0, 0, 514, 46079, 65054, 33577}) == "fe80::202:b3ff:fe1e:8329"
  end
end
