defmodule EspiDni.Plugs.SetSlackUserTest do

  use EspiDni.ConnCase, async: true

  @opts EspiDni.Plugs.SetSlackUser.init(repo: EspiDni.Repo)

  setup do
    team = insert_team
    user = insert_user(team)

    {:ok, user: user, team: team}
  end

  test "returns 401 for a missing user_id" do
    conn =
      build_conn(:get, "/", %{})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.halted
    assert conn.status == 404
  end

  test "returns 404 for an invalid user id and team_id" do
    conn =
      build_conn(:get, "/", %{user_id: "invalid", team_id: "invalid"})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.halted
    assert conn.status == 404
  end

  test "creates a new user and passes through for valid team_id and new user_id", %{team: team} do
    conn =
      build_conn(:get, "/", %{user_id: "new_slack_id", user_name: "newuser", team_id: team.slack_id})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    new_user = Repo.get_by(EspiDni.User, slack_id: "new_slack_id")
    assert conn.assigns.current_user == new_user
    assert new_user.username == "newuser"
    assert new_user.team_id == team.id
    refute conn.halted
  end

  test "returns 404 for an invalid user id in the payload" do
    conn =
      build_conn(:get, "/", %{})
      |> assign(:payload, %{"user_id" => "invalid"})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.halted
    assert conn.status == 404
  end

  test "request passes through when the correct user_id param is present", %{user: user, team: team}  do
    conn =
      build_conn(:get, "/", %{user_id: user.slack_id, team_id: team.slack_id})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.assigns.current_user == user
    refute conn.halted
  end

  test "request passes through when the correct user_id is in the payload", %{user: user, team: team}  do
    conn =
      build_conn(:get, "/", %{})
      |> assign(:payload, %{"user" => %{"id" => user.slack_id}, "team" => %{"id" => team.slack_id}})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.assigns.current_user == user
    refute conn.halted
  end
end
