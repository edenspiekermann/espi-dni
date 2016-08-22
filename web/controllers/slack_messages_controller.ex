defmodule EspiDni.SlackMessageController do
  use EspiDni.Web, :controller

  alias EspiDni.Article

  def new(conn, _params) do
    handle_payload(conn, conn.assigns.payload)
  end

  defp handle_payload(conn, %{"callback_id" => "confirm_article"} = payload) do
    action = List.first(payload["actions"])
    case action do
      %{"name" => "yes", "value" => url} ->
        changeset = Article.changeset(
          %Article{}, %{url: url, user: conn.assigns.current_user.id}
        )
        Repo.insert(changeset)
        text conn, "ok, great, I've registered #{url}"
      %{"name" => "no", "value" => _} ->
        text conn, "ok, can you try adding it with `/add` again please?"
    end
  end

  defp handle_payload(conn, _) do
    conn
    |> put_status(400)
    |> text("Unknown Action")
  end

  defp response(payload) do
    List.first(payload["actions"]) 
  end

end
