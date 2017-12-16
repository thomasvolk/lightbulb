defmodule LighthouseTest do
  use ExUnit.Case
  doctest Lighthouse

  test "greets the world" do
    assert Lighthouse.IpAddress.to_string({10, 1, 0, 23}) == "10.1.0.23"
  end
end
