defmodule Follower.Worker do

  def follow_user(user, config, headers) do
    case HTTPoison.put("#{config[:github_api]}/user/following/" <> user["login"], '', headers) do
      {:ok, body} ->
        IO.puts(user["login"] <> "followed")
      {:error, reason} ->
        IO.puts(user["login"] <> "follow failed")
        IO.inspect reason
    end
  end
end
