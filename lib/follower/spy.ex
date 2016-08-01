defmodule Follower.Spy.Worker do

  def start_link(following_users, config, header) do
    spy(following_users, config, header)
  end

  def spy(users, config, header) do
    import Supervisor.Spec
    Enum.each users, fn user ->
      spawn fn ->
        IO.puts user["login"]
        spawn(Follower.Worker, :follow_user, [user, config, header])
        user_login = user["login"]
        {:ok, %{body: following_users}} = HTTPoison.get(config[:github_api] <> "/users/#{user_login}/following", header)
        IO.puts "generating worker spec"
        worker_spec = worker(Follower.Spy.Worker, [Poison.decode!(following_users), config, header], [restart: :transient])
        Supervisor.start_child(Follower.Supervisor, worker_spec)
      end
    end
  end
end
