defmodule EspiDni.SlackArticleController do
  use EspiDni.Web, :controller

  alias EspiDni.Article

  def new(conn, %{"command" => "/add", "text" => url}) do
    changeset = Article.changeset(%Article{}, %{url: url, user_id: conn.assigns.current_user.id})
    if changeset.valid? do
      render(conn, "confirm.json", url: url)
    else
      text conn, error_string(changeset)
    end
  end

  defp error_string(changeset) do
    Enum.map(changeset.errors, &EspiDni.ErrorHelpers.full_error_message(changeset, &1))
    |> Enum.join(",")
  end
end
