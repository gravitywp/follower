defmodule Follower.Spy do

  def start_link(users, config) do
    headers = [{"Authorization", "token " <> config[:github_token]}]
    spy(users, config, headers)
    receive do
      msg ->
        IO.inspect msg
    end
  end

  def spy(users, config, headers) do
    Enum.each(users, fn(user) ->
      spawn fn ->
        IO.puts user["login"]
        true = Follower.Worker.follow_user(user, config, headers)
        #Follower.TaskQueue.put_task(queue, user["login"])
        user_login = user["login"]
        {:ok, %{body: following_users}} = HTTPoison.get(config[:github_api] <> "/users/#{user_login}/following", headers)
        spawn fn ->
          spy( Poison.decode!(following_users), config, headers)
        end

      end
    end
    )
  end

end
