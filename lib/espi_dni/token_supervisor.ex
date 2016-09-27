defmodule EspiDni.TokenSupervisor do
  use GenServer
  use Supervisor
  use Timex
  require Logger
  alias EspiDni.Team
  alias EspiDni.Repo

  @expiring_soon_in_seconds 60
  @refresh_wait_in_seconds 2_700
  @milliseconds_in_seconds 1_000

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok), do: {:ok, %{}}

  def queue_for_refresh(team) do
    diff = expires_in_unix(team) - :os.system_time(:seconds)

    if diff < @expiring_soon_in_seconds do
      # just do it immediately if it will expire soon
      Task.async fn ->
        __MODULE__.refresh_token!(team)
      end
    else
      # otherwise queue it for later
      queue_delay = queue_delay_ms(diff)
      Logger.info "Queueing token refresh for team: #{team.id} in #{queue_delay}ms"
      :timer.apply_after(queue_delay, __MODULE__, :refresh_token!, [team])
    end
  end

  def refresh_token!(team) do
    Logger.info "Refreshing token for team: #{team.id}"
    new_token =  EspiDni.GoogleAnalyticsClient.get_new_token(team)

    if new_token do
      team
      |> Team.changeset(%{google_token: new_token, google_token_expires_at: new_expires_at(team)})
      |> Repo.update()
      |> elem(1)
      |> queue_for_refresh()
    else
      Logger.error "Could no refresh token for team: #{team.id}"
    end
  end

  defp expires_in_unix(team) do
    Timex.to_unix(Ecto.DateTime.to_erl(team.google_token_expires_at))
  end

  defp new_expires_at(team) do
    Timex.from_unix(expires_in_unix(team) + @refresh_wait_in_seconds)
  end

  defp queue_delay_ms(time) do
    (time - @expiring_soon_in_seconds) * @milliseconds_in_seconds
  end

end
