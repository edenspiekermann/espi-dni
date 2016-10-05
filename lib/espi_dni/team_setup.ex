defmodule EspiDni.TeamSetup do

  require Logger
  alias EspiDni.Repo
  alias EspiDni.Team
  import Ecto.Query, only: [from: 2]

  def start_link do
    start_slack_bots
    :ignore
  end

  defp start_slack_bots do
    for team <- slack_teams, do: start_bot(team)
  end

  defp slack_teams do
    Repo.all(
      from team in EspiDni.Team,
      where: not is_nil(team.slack_token)
    )
  end

  defp start_bot(team) do
    case EspiDni.BotSupervisor.start_bot(team.slack_token) do
      {:ok, _pid} ->
        Logger.info("Successfully started bot for team #{team.id}")
      {:error, error} ->
        Logger.error("Could not start bot for team #{team.id}. Error: #{inspect error}")
    end
  end
end
