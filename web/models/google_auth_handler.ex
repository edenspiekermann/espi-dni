defmodule EspiDni.GoogleAuthHandler do

  @moduledoc """
  Upadte a team with goole credentials from auth response
  """
  alias EspiDni.Team
  alias EspiDni.Repo


  def update_from_auth(team, %{credentials: %{token: token, refresh_token: refresh_token}}) do
    team
    |> Team.changeset(%{google_token: token, google_refresh_token: refresh_token})
    |> Repo.update
  end

  def update_from_auth(team, _) do
    {:error}
  end

end
