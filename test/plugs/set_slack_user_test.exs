defmodule EspiDni.Plugs.SetSlackUserTest do

  use EspiDni.ConnCase, async: true

  @opts EspiDni.Plugs.SetSlackUser.init(repo: EspiDni.Repo)

  setup do
    user = insert_team |> insert_user
    {:ok, conn: conn, user: user}
  end

  test "returns 401 for a missing user_id" do
    conn =
      conn(:get, "/", %{})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.halted
    assert conn.status == 404
  end

  test "returns 404 for an invalid user id param" do
    conn =
      conn(:get, "/", %{user_id: "invalid"})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.halted
    assert conn.status == 404
  end

  test "returns 404 for an invalid user id in the payload" do
    conn =
      conn(:get, "/", %{})
      |> assign(:payload, %{"user_id" => "invalid"})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.halted
    assert conn.status == 404
  end

  test "request passes through when the correct user_id parm is present", %{user: user}  do
    conn =
      conn(:get, "/", %{user_id: user.slack_id})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.assigns.current_user == user
    refute conn.halted
  end

  test "request passes through when the correct user_id is in the payload", %{user: user}  do
    conn =
      conn(:get, "/", %{})
      |> assign(:payload, %{"user" => %{"id" => user.slack_id}})
      |> EspiDni.Plugs.SetSlackUser.call(@opts)

    assert conn.assigns.current_user == user
    refute conn.halted
  end
end
