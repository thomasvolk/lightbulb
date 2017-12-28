defmodule RegistryTest do
  use ExUnit.Case
  doctest Lighthouse.Registry

  test "the Lighthouse.Registry should add nodes and remove expired nodes" do
    Lighthouse.Registry.purge()
    assert Lighthouse.subscribe()
    assert Lighthouse.get_nodes() == []
    Lighthouse.Registry.register_node({10, 1, 1, 50}, "from::test")
    [ {{10, 1, 1, 50}, "from::test"} ] = Lighthouse.Registry.get_nodes()
    assert Lighthouse.Registry.get_nodes() == Lighthouse.get_nodes()

    assert_receive {:lighthouse_nodes_updated, [ {{10, 1, 1, 50}, "from::test"} ] }
    assert_receive {:lighthouse_nodes_updated, [ ] }, 1000

    assert Lighthouse.unsubscribe()
    Lighthouse.Registry.register_node({10, 1, 1, 51}, "from::test")
    [ {{10, 1, 1, 51}, "from::test"} ] = Lighthouse.Registry.get_nodes()
    Lighthouse.Registry.register_node({10, 1, 1, 52}, "from::test")
    [ {{10, 1, 1, 51}, "from::test"}, {{10, 1, 1, 52}, "from::test"} ] = Lighthouse.Registry.get_nodes()
  end

  test "the Lighthouse.Registry sould filter exired nodes" do
    {:ok, past_date} = DateTime.utc_now() |> DateTime.to_unix() |> div(100) |> DateTime.from_unix()
    nodes = Map.new |> Map.put( {127, 1, 1, 0}, {"from::test", past_date})
    assert Lighthouse.Registry.filter_expired(nodes, 0) == %{}
  end
end
