defmodule EspiDni.NotificationMessageControllerTest do
  use EspiDni.ConnCase

  import EspiDni.Factory

  alias EspiDni.NotificationMessage
  @valid_attrs %{text: "some content", type: "some content"}
  @invalid_attrs %{}

  setup do
    team = insert(:team)
    user = insert(:user)

    conn =
      build_conn
      |> assign(:current_user, user)
      |> assign(:current_team, team)

    {:ok, conn: conn, team: team}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, notification_message_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing notification messages"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, notification_message_path(conn, :new)
    assert html_response(conn, 200) =~ "New notification message"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, notification_message_path(conn, :create), notification_message: @valid_attrs
    assert redirected_to(conn) == notification_message_path(conn, :index)
    assert Repo.get_by(NotificationMessage, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, notification_message_path(conn, :create), notification_message: @invalid_attrs
    assert html_response(conn, 200) =~ "New notification message"
  end

  test "shows chosen resource", %{conn: conn} do
    notification_message = Repo.insert! %NotificationMessage{}
    conn = get conn, notification_message_path(conn, :show, notification_message)
    assert html_response(conn, 200) =~ "Show notification message"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, notification_message_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    notification_message = Repo.insert! %NotificationMessage{}
    conn = get conn, notification_message_path(conn, :edit, notification_message)
    assert html_response(conn, 200) =~ "Edit notification message"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    notification_message = Repo.insert! %NotificationMessage{}
    conn = put conn, notification_message_path(conn, :update, notification_message), notification_message: @valid_attrs
    assert redirected_to(conn) == notification_message_path(conn, :show, notification_message)
    assert Repo.get_by(NotificationMessage, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    notification_message = Repo.insert! %NotificationMessage{}
    conn = put conn, notification_message_path(conn, :update, notification_message), notification_message: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit notification message"
  end

  test "deletes chosen resource", %{conn: conn} do
    notification_message = Repo.insert! %NotificationMessage{}
    conn = delete conn, notification_message_path(conn, :delete, notification_message)
    assert redirected_to(conn) == notification_message_path(conn, :index)
    refute Repo.get(NotificationMessage, notification_message.id)
  end
end
