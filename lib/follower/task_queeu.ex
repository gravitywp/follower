defmodule Follower.TaskQueue do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def get_task(server) do
    GenServer.call(server, {:get_task, :ok})
  end

  def put_task(server, task) do
    GenServer.call(server, {:put_task, task})
  end



  ## server callback
  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:get_task, _}, _from, queue) do
    ## TODO: try use case instead
    if length(queue) != 0 do
      {:ok, hd(queue)}
    else
      {:error, "queue is empty"}
    end
    hd(queue)
  end

  def handle_call({:put_task, task}, _from, queue) do

  end
end
