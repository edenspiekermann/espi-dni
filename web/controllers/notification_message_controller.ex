defmodule EspiDni.NotificationMessageController do
  use EspiDni.Web, :controller

  alias EspiDni.NotificationMessage

  use Plug.ErrorHandler
  plug :scrub_params, "notification_message" when action in [:create, :update]

  def index(conn, _params) do
    notification_messages = Repo.all(NotificationMessage)
    render(conn, "index.html", notification_messages: user_messages(conn))
  end

  def new(conn, _params) do
    changeset = NotificationMessage.changeset(%NotificationMessage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"notification_message" => notification_message_params}) do
    params = Map.merge(notification_message_params, %{"team_id" => conn.assigns.current_team.id})
    changeset = NotificationMessage.changeset(%NotificationMessage{}, params)

    case Repo.insert(changeset) do
      {:ok, _notification_message} ->
        conn
        |> put_flash(:info, "Notification message created successfully.")
        |> redirect(to: notification_message_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    notification_message = get_user_message(conn, id)
    render(conn, "show.html", notification_message: notification_message)
  end

  def edit(conn, %{"id" => id}) do
    notification_message = get_user_message(conn, id)
    changeset = NotificationMessage.changeset(notification_message)
    render(conn, "edit.html", notification_message: notification_message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "notification_message" => notification_message_params}) do
    notification_message = get_user_message(conn, id)
    changeset = NotificationMessage.changeset(notification_message, notification_message_params)

    case Repo.update(changeset) do
      {:ok, notification_message} ->
        conn
        |> put_flash(:info, "Notification message updated successfully.")
        |> redirect(to: notification_message_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", notification_message: notification_message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    notification_message = get_user_message(conn, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(notification_message)

    conn
    |> put_flash(:info, "Notification message deleted successfully.")
    |> redirect(to: notification_message_path(conn, :index))
  end

  defp user_messages(conn) do
    team_id = conn.assigns.current_team.id
    Repo.all(
      from notification_message in NotificationMessage,
      where: notification_message.team_id == ^team_id
    )
  end

  defp get_user_message(conn, id) do
    team_id = conn.assigns.current_team.id
    Repo.one!(
      from notification_message in NotificationMessage,
      where: notification_message.id == ^id,
      where: notification_message.team_id == ^team_id
    )
  end

end
