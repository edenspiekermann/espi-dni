defmodule EspiDni.TeamSetup do

  require Logger
  alias EspiDni.Repo
  alias EspiDni.Team
  import Ecto.Query, only: [from: 2]

  def start_link do
    start_slack_bots
    start_token_workers
    start_analytic_workers
    :ignore
  end

  defp start_slack_bots do
    for team <- slack_teams, do: start_bot(team)
  end

  defp start_token_workers do
    for team <- teams_with_refresh_tokens, do: queue_token_refresh(team)
  end

  defp start_analytic_workers do
    for team <- teams_with_analytics_configs, do: start_analytics(team)
  end

  defp slack_teams do
    Repo.all(
      from team in EspiDni.Team,
      where: not is_nil(team.slack_token)
    )
  end

  defp teams_with_refresh_tokens do
    Repo.all(
      from team in Team,
      where: not is_nil(team.google_refresh_token),
      where: not is_nil(team.google_token_expires_at)
    )
  end

  defp teams_with_analytics_configs do
    Repo.all(
      from team in EspiDni.Team,
      where: not is_nil(team.google_token),
      where: not is_nil(team.google_property_id)
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

  defp queue_token_refresh(team) do
    case EspiDni.TokenSupervisor.start_token_worker(team) do
      {:ok, _pid} ->
        Logger.info("Successfully started token worker for team #{team.id}")
      {:error, error} ->
        Logger.error("Could not start token worker for team #{team.id}. Error: #{inspect error}")
    end
  end

  defp start_analytics(team) do
    case EspiDni.AnalyticsSupervisor.start_anlaytics_worker(team) do
      {:ok, _pid} ->
        Logger.info("Successfully started anlaytic worker for team #{team.id}")
      {:error, error} ->
        Logger.error("Could not start anlaytic worker for team #{team.id}. Error: #{inspect error}")
    end
  end
end
