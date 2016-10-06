defmodule EspiDni.SlackMessageController do
  use EspiDni.Web, :controller

  alias EspiDni.Article

  def new(conn, _params) do
    handle_payload(conn, conn.assigns.payload)
  end

  defp handle_payload(conn, %{"callback_id" => "confirm_article"} = payload) do
    case slack_action(payload) do
      %{"name" => "yes", "value" => url} ->
        case create_article(conn, url) do
          {:ok, _article} ->
            text conn, gettext("Article Registered", %{url: url, manage_url: article_url(conn, :index)})
          {:error, changeset} ->
            text conn, error_string(changeset)
        end
      %{"name" => "no", "value" => _} ->
        text conn, gettext("Article Retry")
    end
  end

  defp handle_payload(conn, _) do
    conn
    |> put_status(400)
    |> text("Unknown Action")
  end

  defp slack_action(payload) do
    List.first(payload["actions"])
  end

  defp create_article(conn, url) do
    Article.changeset(%Article{}, %{url: url, user_id: current_user_id(conn)})
    |> Repo.insert()
  end

  defp current_user_id(conn) do
    conn.assigns.current_user.id
  end

  defp error_string(changeset) do
    Enum.map(changeset.errors, &EspiDni.ErrorHelpers.full_error_message(changeset, &1))
    |> Enum.join(",")
  end

end
