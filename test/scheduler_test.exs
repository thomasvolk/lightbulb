
defmodule SchedulerTest do
  use ExUnit.Case
  doctest Lighthouse.Scheduler

  setup do
    {:ok, pid} = start_supervised SchedulerTest.Counter
    %{conter_pid: pid}
  end

  test "the Lighthouse.Scheduler should schedule method calls", %{conter_pid: _cpid} do
    {:ok, _pid} = Lighthouse.Scheduler.start_link({10, &SchedulerTest.Counter.increase/0 })
    :timer.sleep 30
    assert SchedulerTest.Counter.get() == 2
  end
end

defmodule SchedulerTest.Counter do
  use Agent

  def start_link(_opts), do: Agent.start_link(fn -> 0 end, name: __MODULE__)

  def get(), do: Agent.get(__MODULE__, fn c -> c end)

  def increase(), do: Agent.update(__MODULE__, fn c -> c + 1 end)
end
