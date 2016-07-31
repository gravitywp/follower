defmodule Follower.Spy.Worker do

  def start_link(following_users, config, header) do
    spy(following_users, config, header)
    receive do
      :stop -> :ok
    end
  end

  def spy(users, config, header) do
    Enum.each users, fn user ->
      spawn fn ->
        IO.puts user["login"]
        true = spawn(Follower.Worker, :follow_user, [user, config, header])
        user_login = user["login"]
        {:ok, %{body: following_users}} = HTTPoison.get(config[:github_api] <> "/users/#{user_login}/following", header)
        Supervisor.start_child(Follower.Supervisor, [following_users, config, header])
      end
    end
  end
end
