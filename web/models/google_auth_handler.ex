defmodule EspiDni.GoogleAuthHandler do

  @expected_param_count 3
  @moduledoc """
  Upadte a team with goole credentials from auth response
  """
  alias EspiDni.Team
  alias EspiDni.Repo
  use Timex

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
    EspiDni.TokenSupervisor.start_token_worker(team)
    {:ok, team}
  end
  def queue_for_refresh(_), do: {:error}

  defp params_from_auth(%{token: token, refresh_token: refresh_token, expires_at: expires_at}) do
    %{
      google_token: token,
      google_refresh_token: refresh_token,
      google_token_expires_at: Timex.from_unix(expires_at),
    }
  end
  defp params_from_auth(_), do: %{}
end
