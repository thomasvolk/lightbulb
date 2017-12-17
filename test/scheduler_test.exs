
defmodule SchedulerTest do
  use ExUnit.Case
  doctest Lighthouse.Scheduler

  setup do
    {:ok, pid} = start_supervised({SchedulerTest.Counter, self()})
    %{conter_pid: pid}
  end

  test "the Lighthouse.Scheduler should schedule method calls", %{conter_pid: _cpid} do
    {:ok, _pid} = Lighthouse.Scheduler.start_link({5, &SchedulerTest.Counter.increase/0 })
    result = receive do
      10 ->
        :ok
    after
      2_000 ->
        assert false, "timeout! expected count not reached"
    end
    assert result == :ok
  end
end

defmodule SchedulerTest.Counter do
  use Agent

  def start_link(receiver), do: Agent.start_link(fn -> {0, receiver} end, name: __MODULE__)

  def increase() do
    Agent.update(__MODULE__, fn {c, receiver} ->
      new_count = c + 1
      send(receiver, new_count)
      {new_count, receiver}
    end)
  end
end
