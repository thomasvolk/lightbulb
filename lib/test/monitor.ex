defmodule Lightbulb.Test.Monitor do
  use GenServer

  def start_link(listener) do
    GenServer.start_link(__MODULE__, {listener}, [name: __MODULE__])
  end

  def init(state) do
    {:ok, state }
  end

  def send(data) do
    if active?() do
      GenServer.cast(__MODULE__, {:send, data})
    end
  end

  def handle_cast({:send, data}, { listener }) do
    send(listener, data)
    {:noreply, { listener } }
  end

  def active?() do
    GenServer.whereis(__MODULE__) != nil
  end

end
