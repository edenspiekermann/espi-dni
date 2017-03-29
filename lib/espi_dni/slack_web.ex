defmodule EspiDni.SlackWeb do

  @moduledoc """
  A module for dealing with slacks web API
  Uses https://github.com/BlakeWilliams/Elixir-Slack
  """

  use Slack

  import Ecto.Query, only: [from: 1, from: 2]
  alias EspiDni.Repo
  alias EspiDni.Team

  @doc"""
  Sends a user a message
  """
  def send_message(user, message) do
    Slack.Web.Chat.post_message(
      user.slack_id,
      message,
      %{token: token(user)}
    )
  end

  defp token(user) do
    Repo.one(
      from team in Team,
      where: team.id == ^user.team_id,
      select: team.slack_token
    )
  end

end
