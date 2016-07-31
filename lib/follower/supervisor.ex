defmodule Follower.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    Follower.Spy.Server = :ets.new(Follower.Spy.Server, [:named_table, :public, :set])
    children = [
      worker(Follower.Spy.Server, [])
    ]
    supervise(children, [strategy: :one_for_one])
  end

end
