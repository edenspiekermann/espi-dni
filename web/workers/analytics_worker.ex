defmodule EspiDni.AnalyticsWorker do

  require Logger

  @thirty_minutes 1_800

  def perform(team_id) do
    Logger.info "Runing google analytics job for team: #{team_id}"
    team = EspiDni.Repo.get(EspiDni.Team, team_id)
    EspiDni.AnalyticsManager.retrieve_anlaytics(team)
    EspiDni.AnalyticsWorker.queue_job(team)
  end

  def queue_job(team) do
    EspiDni.UniqueQueue.enqueue_in(EspiDni.AnalyticsWorker, team, @thirty_minutes)
  end

end
