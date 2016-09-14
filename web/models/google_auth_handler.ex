defmodule EspiDni.GoogleAuthHandler do

  @moduledoc """
  Upadte a team with goole credentials from auth response
  """
  alias EspiDni.Team
  alias EspiDni.Repo

  def update_from_auth(team, auth) do
    team
    |> Team.changeset(google_params(auth))
    |> Repo.update
  end

  defp google_params(auth) do
    %{
      google_token: auth.credentials.token,
      google_refresh_token: auth.credentials.refresh_token
    }
  end
end
