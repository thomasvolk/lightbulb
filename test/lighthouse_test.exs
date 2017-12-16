defmodule LighthouseTest do
  use ExUnit.Case
  doctest Lighthouse

  test "greets the world" do
    assert Lighthouse.hello() == :world
  end
end
