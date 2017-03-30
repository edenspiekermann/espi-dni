defmodule EspiDni.TeamFromAuth do

  @moduledoc """
  Create or retrieve the team from a Slack oauth request
  """

  alias Ueberauth.Auth
  alias EspiDni.Repo
  alias EspiDni.Team


  @doc """
  Returns or creates a team form a Slack oauth request
  """
  def find_or_create(%Auth{} = auth) do
    auth
    |> team_params
    |> create_or_update
  end

  # extracts the team params from the oauth response
  defp team_params(auth) do
    %{
      slack_id:    auth.credentials.other.team_id,
      slack_token: bot_token(auth),
      name:        auth.credentials.other.team,
      url:         auth.credentials.other.team_url
    }
  end

  # creates or updates the team from the params
  defp create_or_update(%{slack_id: slack_id} = params) do
    team_params = scrubbed_params(params)

    case team_by_slack_id(slack_id) do
      nil ->
        %Team{}
        |> Team.changeset(team_params)
        |> Repo.insert
      existing_team ->
        existing_team
        |> Team.changeset(team_params)
        |> Repo.update
    end
  end

  defp team_by_slack_id(slack_id) do
    Repo.get_by(Team, slack_id: slack_id)
  end

  defp bot_token(auth) do
    auth.extra.raw_info.token.other_params["bot"]["bot_access_token"]
  end

  # removes any nil values
  def scrubbed_params(params) do
    params
    |> Enum.filter(fn {_, value} -> !is_nil(value) end)
    |> Enum.into(%{})
  end

end
