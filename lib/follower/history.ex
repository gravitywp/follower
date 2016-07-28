defmodule Follower.History do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :history, [])
  end

  def done?(server, task) do
    GenServer.call(server, {:done?, task})
  end

  def done(server, task) do
    GenServer.call(server, {:done, task})
  end

  ## server callback
  def init(table) do
    {:ok, :ets.new(table, [:set, :protected, :named_table, read_concurrency: true])}
  end

  def handle_call({:done?, task}, _from, history) do
    :ets.lookup(history, task)
  end

  def handle_call({:done, task}, _from, history) do
    :ets.insert(history, task)
  end

end
