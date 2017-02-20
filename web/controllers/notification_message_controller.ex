defmodule EspiDni.NotificationMessageController do
  use EspiDni.Web, :controller

  alias EspiDni.NotificationMessage

  def index(conn, _params) do
    notification_messages = Repo.all(NotificationMessage)
    render(conn, "index.html", notification_messages: notification_messages)
  end

  def new(conn, _params) do
    changeset = NotificationMessage.changeset(%NotificationMessage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"notification_message" => notification_message_params}) do
    changeset = NotificationMessage.changeset(%NotificationMessage{}, notification_message_params)

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
    notification_message = Repo.get!(NotificationMessage, id)
    render(conn, "show.html", notification_message: notification_message)
  end

  def edit(conn, %{"id" => id}) do
    notification_message = Repo.get!(NotificationMessage, id)
    changeset = NotificationMessage.changeset(notification_message)
    render(conn, "edit.html", notification_message: notification_message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "notification_message" => notification_message_params}) do
    notification_message = Repo.get!(NotificationMessage, id)
    changeset = NotificationMessage.changeset(notification_message, notification_message_params)

    case Repo.update(changeset) do
      {:ok, notification_message} ->
        conn
        |> put_flash(:info, "Notification message updated successfully.")
        |> redirect(to: notification_message_path(conn, :show, notification_message))
      {:error, changeset} ->
        render(conn, "edit.html", notification_message: notification_message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    notification_message = Repo.get!(NotificationMessage, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(notification_message)

    conn
    |> put_flash(:info, "Notification message deleted successfully.")
    |> redirect(to: notification_message_path(conn, :index))
  end
end
