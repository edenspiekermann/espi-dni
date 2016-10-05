defmodule EspiDni.Plugs.SetSessionDataTest do

  use EspiDni.ConnCase, async: true

  @opts EspiDni.Plugs.SetSessionData.init(repo: EspiDni.Repo)

  test "request passes through when data is not present in session" do
    conn =
      build_conn
      |> bypass_through(EspiDni.Router, :browser)
      |> get("/")
      |> EspiDni.Plugs.SetSessionData.call(@opts)

    assert conn.assigns.current_user == nil
    assert conn.assigns.current_team == nil
    refute conn.halted
  end

  describe "with user and team ids in the session" do
    setup do
      team = insert_team()
      user = team |> insert_user()

      conn =
        build_conn
        |> bypass_through(EspiDni.Router, :browser)
        |> get("/")
        |> put_session(:team_id, team.id)
        |> put_session(:user_id, user.id)

      {:ok, conn: conn, team: team, user: user}
    end

    test "request passes through and adds user and team to conn", %{conn: conn, team: team, user: user} do
      conn = EspiDni.Plugs.SetSessionData.call(conn, @opts)
      assert conn.assigns.current_user == user
      assert conn.assigns.current_team == team
      refute conn.halted
    end
  end
end
