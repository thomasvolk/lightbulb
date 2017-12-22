defmodule RegistryTest do
  use ExUnit.Case
  doctest Lighthouse.Registry

  test "the Lighthouse.Registry should manage ip addresses" do
    Lighthouse.Registry.listen()
    assert Lighthouse.Registry.get_nodes() == %{}
    Lighthouse.Registry.register_node({10, 1, 1, 50})
    %{ {10, 1, 1, 50} => _ } = Lighthouse.Registry.get_nodes()
    assert Lighthouse.Registry.get_nodes(0) == %{}
    Lighthouse.Registry.register_node({10, 1, 1, 51})
    %{ {10, 1, 1, 50} => _, {10, 1, 1, 51} => _ } = Lighthouse.Registry.get_nodes(300000)

    result = receive do
      {:update, %{ {10, 1, 1, 50} => _ }} ->
        :ok
    after
      100 ->
        assert false, "timeout! expected message not reached"
    end
    assert result == :ok
  end
end
