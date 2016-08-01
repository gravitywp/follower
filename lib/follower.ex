defmodule Follower do
  use Application

  def start(_type, _args) do
    Follower.Supervisor.start_link
  end

  def start_child do
    import Supervisor.Spec

    user_information = get_user_information
    worker_spec = worker(Follower.Spy.Worker, [user_information.following_users, user_information.config, user_information.header], [restart: :transient])
    Supervisor.start_child(Follower.Supervisor, worker_spec)
  end

  def get_user_information do
    config = Application.get_all_env(:follower)
    header = [{"Authorization", "token " <> config[:github_token]}]
    #    {:ok, queue} = Follower.TaskQueue.start_link
    login_user = case HTTPoison.get(config[:github_api] <> "/user", header) do
                   {:ok, %{body: userJson}} ->
                     Poison.decode!(userJson)["login"]
                   {:error, reason} ->
                     IO.inspect reason
                     raise "error courred for getting your github information"
                 end

    IO.inspect login_user
    {:ok, %{body: following_json}} = HTTPoison.get(config[:github_api] <> "/users/#{login_user}/following")
    following_users = Poison.decode!(following_json)
    %{
      following_users: following_users,
      config: config,
      header: header
    }
  end
end
