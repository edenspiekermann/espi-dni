defmodule EspiDni.TeamFromAuth do

  @moduledoc """
  Create or retreive the team from an auth request
  """
  import Ecto.Query
  alias Ueberauth.Auth
  alias EspiDni.Repo
  alias EspiDni.Team


  def find_or_create(%Auth{} = auth) do
    result = auth.credentials
    |> team_params
    |> create_or_update
  end

  def create_or_update(%{slack_id: slack_id} = params) do
    case team_by_slack_id(slack_id) do
      nil ->
        Team.changeset(%Team{}, params)
        |> Repo.insert
      existing_team ->
        Team.changeset(existing_team, params)
        |> Repo.update
    end
  end

  defp team_by_slack_id(slack_id) do
    Repo.one(from t in Team, where: t.slack_id == ^slack_id)
  end

  defp team_params(credentials) do
    %{
      slack_id: credentials.other.team_id,
      token:    credentials.token,
      name:     credentials.other.team,
      url:      credentials.other.team_url
    }
  end
end
