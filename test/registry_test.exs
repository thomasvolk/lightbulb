defmodule RegistryTest do
  use ExUnit.Case
  doctest Lighthouse.Registry

  def check_for_message(_message, timeout \\ 1000) do
    result = receive do
      _message ->
        :ok
    after
      timeout ->
        assert false, "timeout! expected message not reached"
    end
    assert result == :ok
  end

  test "the Lighthouse.Registry should add nodes and remove expired nodes" do
    assert Lighthouse.subscribe()
    assert Lighthouse.Registry.get_nodes() == []
    Lighthouse.Registry.register_node({10, 1, 1, 50}, "from::test")
    [ {{10, 1, 1, 50}, "from::test"} ] = Lighthouse.Registry.get_nodes()
    assert Lighthouse.Registry.get_nodes() == Lighthouse.get_nodes()

    check_for_message({:lighthouse_nodes_updated, [ {10, 1, 1, 50} ] })
    check_for_message({:lighthouse_nodes_updated, [ ] })

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
