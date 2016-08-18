defmodule EspiDni.SlackArticleController do
  use EspiDni.Web, :controller

  plug EspiDni.Plugs.RequireSlackToken
  plug EspiDni.Plugs.SetSlackUser, repo: EspiDni.Repo
  plug :ensure_user when action in [:new]

  alias EspiDni.Article

  def new(conn, %{"command" => "/add", "text" => url } = params) do
    changeset = Article.changeset(%Article{}, %{url: url, user: conn.assigns.current_user.id})
    if changeset.valid? do
      render(conn, "confirm.json", url: url)
    else
      text conn, Keyword.get(changeset.errors, :url)
    end
  end

  defp ensure_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn |> send_resp(404, "Unknown User") |> halt
    end
  end

end
