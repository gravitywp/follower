defmodule Follower do
  use Application

  def start do
    Follower.Supervisor.start_link
  end

end
