defmodule Follower.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    config = Application.get_all_env(:follower)
    headers = [{"Authorization", "token " <> config[:github_token]}]
    #    {:ok, queue} = Follower.TaskQueue.start_link
    login_user = case HTTPoison.get(config[:github_api] <> "/user", headers) do
                   {:ok, %{body: userJson}} ->
                     Poison.decode!(userJson)["login"]
                   {:error, reason} ->
                     IO.inspect reason
                     raise "error courred for getting your github information"
                 end

     {:ok, %{body: following_json}} = HTTPoison.get(config[:github_api] <> "/users/#{login_user}/following")
     following_users = Poison.decode!(following_json)
    end

    children = [
      worker(Follower.Spy, [following_users, config])
    ]
    supervise(children, strategy: :one_for_one)
  end

end
