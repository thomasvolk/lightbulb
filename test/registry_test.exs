defmodule RegistryTest do
  use ExUnit.Case
  doctest Light.Registry

  setup do
    Light.Registry.purge()
    Light.subscribe()

    on_exit fn ->
      Light.unsubscribe()
    end
  end

  test "the Light.Registry should add nodes and remove expired nodes" do
    assert Light.get_nodes() == []
    Light.Registry.register_node({10, 1, 1, 50}, "from::test")
    [ {{10, 1, 1, 50}, "from::test"} ] = Light.Registry.get_nodes()
    assert Light.Registry.get_nodes() == Light.get_nodes()

    assert_receive {:light_nodes_updated, [ {{10, 1, 1, 50}, "from::test"} ] }
    assert_receive {:light_nodes_updated, [ ] }, 1000

    Light.Registry.register_node({10, 1, 1, 51}, "from::test")
    [ {{10, 1, 1, 51}, "from::test"} ] = Light.Registry.get_nodes()
    Light.Registry.register_node({10, 1, 1, 52}, "from::test")
    [ {{10, 1, 1, 51}, "from::test"}, {{10, 1, 1, 52}, "from::test"} ] = Light.Registry.get_nodes()
  end

  test "the Light.Registry sould filter exired nodes" do
    {:ok, past_date} = DateTime.utc_now() |> DateTime.to_unix() |> div(100) |> DateTime.from_unix()
    nodes = Map.new |> Map.put( {127, 1, 1, 0}, {"from::test", past_date})
    assert Light.Registry.filter_expired(nodes, 0) == %{}
  end
end
