defmodule EspiDni.TokenRefreshWorker do

  require Logger

  @fourty_five_minutes 2_700

  def perform(team_id) do
    Logger.info "Runing refresh job for team: #{team_id}"
    team = EspiDni.Repo.get(EspiDni.Team, team_id)
    EspiDni.TokenManager.refresh_token!(team)
    EspiDni.TokenRefreshWorker.queue_job(team)
  end

  def queue_job(team) do
    EspiDni.UniqueQueue.enqueue_in(EspiDni.TokenRefreshWorker, team, @fourty_five_minutes)
  end

end
