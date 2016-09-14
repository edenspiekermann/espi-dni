defmodule EspiDni.GoogleAuthHandlerTest do
  use EspiDni.ModelCase

  alias EspiDni.GoogleAuthHandler

  @valid_params %{credentials: %{token: "atoken", refresh_token: "refresh_token"}}

  setup do
    team = insert_team
    {:ok, team: team}
  end

  test "update_from_auth with valid params", %{team: team} do
    case GoogleAuthHandler.update_from_auth(team, @valid_params) do
      {:ok, team} ->
        assert team.google_token == "atoken"
        assert team.google_refresh_token == "refresh_token"
    end
  end
end
