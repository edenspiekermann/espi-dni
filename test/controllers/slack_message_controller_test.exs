defmodule EspiDni.SlackMessageControllerTest do
  use EspiDni.ConnCase

  setup do
    user = insert_team |> insert_user
    {:ok, conn: conn, user: user}
  end

  test "returns a 401 for an invalid token", %{conn: conn} do
    params = %{ payload: Poison.encode!(%{"token" => "invalid"})}
    conn = post conn, slack_message_path(conn, :new), params

    assert conn.status == 401
    assert conn.resp_body =~ "Unauthorized"
  end

  test "returns a 404 for an unknown user", %{conn: conn} do
    params = %{ payload: Poison.encode!(%{"token" => slack_token, user_id: "invalid"})}
    conn = post conn, slack_message_path(conn, :new), params

    assert conn.status == 404
    assert conn.resp_body =~ "Unknown User"
  end

  test "returns an error for an unknown callback", %{conn: conn, user: user} do
    payload = Poison.encode!(
      %{
          token: slack_token,
          user: %{ id: user.slack_id},
          callback_id: "invalid"
      }
    )
    conn = post conn, slack_message_path(conn, :new), %{ payload: payload}

    assert conn.status == 400
    assert conn.resp_body =~ "Unknown Action"
  end

  test "returns a message for a 'no' confirm_article action", %{conn: conn, user: user} do
    payload = Poison.encode!(
      %{
        token: slack_token,
        user: %{ id: user.slack_id},
        callback_id: "confirm_article",
        actions: [ %{name: "no", value: "url"} ]
      }
    )
    conn = post conn, slack_message_path(conn, :new), %{ payload: payload}

    assert text_response(conn, 200) =~ "ok, can you try adding it with `/add` again please?"
  end

  test "saves article and returns a message for a 'yes' confirm_article action", %{conn: conn, user: user} do
    payload = Poison.encode!(
      %{
        token: slack_token,
        user: %{ id: user.slack_id},
        callback_id: "confirm_article",
        actions: [ %{name: "yes", value: "http://www.example.com"} ]
      }
    )
    conn = post conn, slack_message_path(conn, :new), %{ payload: payload}
    assert Repo.get_by(EspiDni.Article, url: "http://www.example.com")

    assert text_response(conn, 200) =~ "ok, great, I've registered http://www.example.com"
  end
end
