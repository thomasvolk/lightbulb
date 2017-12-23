defmodule RegistryTest do
  use ExUnit.Case
  doctest Lighthouse.Registry

  test "the Lighthouse.Registry should manage ip addresses" do
    assert Lighthouse.subscribe()
    assert Lighthouse.Registry.get_nodes() == %{}
    Lighthouse.Registry.register_node({10, 1, 1, 50})
    %{ {10, 1, 1, 50} => _ } = Lighthouse.Registry.get_nodes()
    assert Lighthouse.Registry.get_nodes() == Lighthouse.get_nodes()
    assert Lighthouse.unsubscribe()
    Lighthouse.Registry.register_node({10, 1, 1, 51})
    %{ {10, 1, 1, 50} => _, {10, 1, 1, 51} => _ } = Lighthouse.Registry.get_nodes()

    result = receive do
      {:updated, %{ {10, 1, 1, 50} => _ }} ->
        :ok
    after
      100 ->
        assert false, "timeout! expected message not reached"
    end
    assert result == :ok
  end

  test "the Lighthouse.Registry sould filter exired nodes" do
    {:ok, past_date} = DateTime.utc_now() |> DateTime.to_unix() |> div(100) |> DateTime.from_unix()
    nodes = Map.new |> Map.put( {127, 1, 1, 0}, past_date)
    assert Lighthouse.Registry.filter_expired(nodes, 0) == %{}
  end
end
