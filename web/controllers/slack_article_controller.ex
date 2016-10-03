defmodule EspiDni.SlackArticleController do
  use EspiDni.Web, :controller

  alias EspiDni.Article

  def new(conn, %{"command" => "/add", "text" => url}) do
    changeset = Article.changeset(%Article{}, %{url: url, user_id: conn.assigns.current_user.id})
    if changeset.valid? do
      render(conn, "confirm.json", url: url)
    else
      text conn, Keyword.get(changeset.errors, :url)
    end
  end

end
