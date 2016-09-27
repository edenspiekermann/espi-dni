defmodule EspiDni.GoogleAuthHandlerTest do
  use EspiDni.ModelCase
  alias EspiDni.GoogleAuthHandler

  @valid_params %{credentials: %{token: "atoken", refresh_token: "refresh_token", expires_at: 1474980702}}
  @invalid_params %{credentials: %{}}

  setup do
    team = insert_team
    {:ok, team: team}
  end

  test "update_from_auth with valid params", %{team: team} do
    case GoogleAuthHandler.update_from_auth(team, @valid_params) do
      {:ok, team} ->
        assert team.google_token == "atoken"
        assert team.google_refresh_token == "refresh_token"
        assert Ecto.DateTime.to_erl(team.google_token_expires_at) == Timex.to_erl(Timex.from_unix(1474980702))
    end
  end

  test "something", %{team: team} do
    assert GoogleAuthHandler.update_from_auth(team, @invalid_params) == {:error}
  end
end
