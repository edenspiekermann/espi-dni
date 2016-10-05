defmodule EspiDni.TokenManager do

  use Timex
  require Logger
  alias EspiDni.GoogleAnalyticsClient
  alias EspiDni.Team
  alias EspiDni.Repo

  def refresh_token!(team) do
    Logger.info "Refreshing token for team: #{team.id}"
    google_response = GoogleAnalyticsClient.get_new_token(team)

    unless Enum.empty?(google_response) do
      team
      |> Team.changeset(changeset_from_response(google_response))
      |> Repo.update!
    else
      Logger.error "Could no refresh token for team: #{team.id}"
    end
  end

  defp changeset_from_response(response) do
    expires_at = Timex.now |> Timex.shift(seconds: response.expires_in)
    %{google_token: response.access_token, google_token_expires_at: expires_at}
  end

end
