
defmodule Lighthouse.Scheduler do
  use GenServer
  require Logger

  def start_link({interval, func}) do
    GenServer.start_link(__MODULE__, {interval, func}, [name: __MODULE__])
  end

  defp schedule_next(interval) do
    Process.send_after(self(), :schedule_next, interval)
  end

  def init({interval, func} = state) do
    Logger.info "start #{__MODULE__} interval=#{interval} func=#{inspect(func)}"
    schedule_next(interval)
    {:ok, state }
  end

  def handle_info(:schedule_next, {interval, func} = state) do
    func.()
    schedule_next(interval)
    {:noreply, state}
  end
end
