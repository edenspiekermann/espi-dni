defmodule EspiDni.TokenWorker do

  use GenServer
  use Timex
  require Logger
  alias EspiDni.GoogleAnalyticsClient
  alias EspiDni.Team
  alias EspiDni.Repo

  @expiring_soon_in_seconds 60
  @refresh_wait_in_seconds 2_700
  @milliseconds_in_seconds 1_000

  def start_link(team) do
    GenServer.start_link(__MODULE__, team, name: via_tuple(team))
  end

  def init(team) do
    Logger.info("Initializing TokenWorker")
    queue_for_refresh(team)
  end

  defp via_tuple(team) do
    {:via, :gproc, {:n, :l, {:token_worker, team.name}}}
  end

  def queue_for_refresh(team) do
    diff = expires_in_unix(team) - :os.system_time(:seconds)

    if diff < @expiring_soon_in_seconds do
      refresh_now(team)
    else
      refresh_later(team, queue_delay_ms(diff))
    end
  end

  def refresh_token!(team) do
    Logger.info "Refreshing token for team: #{team.id}"
    new_token = GoogleAnalyticsClient.get_new_token(team)

    if new_token do
      team
      |> Team.changeset(%{google_token: new_token, google_token_expires_at: new_expires_at(team)})
      |> Repo.update!
      |> queue_for_refresh()
    else
      Logger.error "Could no refresh token for team: #{team.id}"
    end
  end

  defp refresh_now(team) do
    __MODULE__.refresh_token!(team)
  end

  defp refresh_later(team, delay) do
    Logger.info "Queueing token refresh for team: #{team.id} in #{delay}ms"
    :timer.apply_after(delay, __MODULE__, :refresh_token!, [team])
  end

  defp expires_in_unix(team) do
    Timex.to_unix(Ecto.DateTime.to_erl(team.google_token_expires_at))
  end

  defp new_expires_at(team) do
    Timex.from_unix(expires_in_unix(team) + @refresh_wait_in_seconds)
  end

  defp queue_delay_ms(time) do
    remaining_time = min(time, (time - @expiring_soon_in_seconds))
    remaining_time * @milliseconds_in_seconds
  end

end
