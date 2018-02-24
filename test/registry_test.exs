defmodule RegistryTest do
  use ExUnit.Case
  doctest Lightbulb.Registry

  setup do
    Lightbulb.Registry.purge()
    Lightbulb.subscribe()

    on_exit fn ->
      Lightbulb.unsubscribe()
    end
  end

  test "the Lightbulb.Registry should add nodes and remove expired nodes" do
    assert Lightbulb.get_nodes() == []
    Lightbulb.Registry.register_node({10, 1, 1, 50}, "from::test")
    [ {{10, 1, 1, 50}, "from::test"} ] = Lightbulb.Registry.get_nodes()
    assert Lightbulb.Registry.get_nodes() == Lightbulb.get_nodes()

    assert_receive {:lightbulb_nodes_updated, [ {{10, 1, 1, 50}, "from::test"} ] }
    assert_receive {:lightbulb_nodes_updated, [ ] }, 1000

    Lightbulb.Registry.register_node({10, 1, 1, 51}, "from::test")
    [ {{10, 1, 1, 51}, "from::test"} ] = Lightbulb.Registry.get_nodes()
    Lightbulb.Registry.register_node({10, 1, 1, 52}, "from::test")
    [ {{10, 1, 1, 51}, "from::test"}, {{10, 1, 1, 52}, "from::test"} ] = Lightbulb.Registry.get_nodes()
  end

  test "the Lightbulb.Registry sould filter exired nodes" do
    {:ok, past_date} = DateTime.utc_now() |> DateTime.to_unix() |> div(100) |> DateTime.from_unix()
    nodes = Map.new |> Map.put( {127, 1, 1, 0}, {"from::test", past_date})
    assert Lightbulb.Registry.filter_expired(nodes, 0) == %{}
  end
end
