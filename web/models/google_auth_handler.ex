defmodule EspiDni.GoogleAuthHandler do

  @moduledoc """
  Update a team with Google credentials from oauth response
  """

  @expected_param_count 3
  alias EspiDni.Team
  alias EspiDni.Repo
  use Timex

  @doc """
  Updates the team with the oauth response from Google.
  Save the new credentials to the team, and then enqueues a job to refresh the
  teams Google oauth token
  """
  def update_from_auth(team, %{credentials: credentials}) do
    params =  params_from_auth(credentials)

    case map_size(params) do
      @expected_param_count ->
        team
        |> Team.changeset(params)
        |> Repo.update
        |> queue_for_refresh
      _ -> {:error}
    end
  end

  def update_from_auth(_, _) do
    {:error}
  end

  def queue_for_refresh({:ok, team}) do
    EspiDni.TokenRefreshWorker.queue_job(team)
    {:ok, team}
  end
  def queue_for_refresh(_), do: {:error}

  # the params we expect to receive from the Google oauth response
  defp params_from_auth(%{token: token, refresh_token: refresh_token, expires_at: expires_at}) do
    %{
      google_token: token,
      google_refresh_token: refresh_token,
      google_token_expires_at: Timex.from_unix(expires_at),
    }
  end
  defp params_from_auth(_), do: %{}
end
