defmodule EspiDni.ArticleController do
  use EspiDni.Web, :controller

  alias EspiDni.Article

  plug :authenticate
  plug :scrub_params, "article" when action in [:create, :update]

  def index(conn, _params) do
    team = conn.assigns.current_team
    render(conn, "index.html", articles: user_articles(conn), current_team: team)
  end

  def new(conn, _params) do
    changeset = Article.changeset(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    params = Map.merge(article_params, %{"user_id" => conn.assigns.current_user.id})
    changeset = Article.changeset(%Article{}, params)

    case Repo.insert(changeset) do
      {:ok, _article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: article_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", article: get_article(id))
  end

  def edit(conn, %{"id" => id}) do
    article = get_user_article(conn, id)
    changeset = Article.changeset(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = get_user_article(conn, id)
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = get_user_article(conn, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: article_path(conn, :index))
  end

  defp user_articles(conn) do
    user_id = conn.assigns.current_user.id
    Repo.all(
      from article in Article,
      where: article.user_id == ^user_id
    )
  end

  defp get_user_article(conn, id) do
    user_id = conn.assigns.current_user.id
    Repo.one!(
      from article in Article,
      where: article.id == ^id,
      where: article.user_id == ^user_id
    )
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_team && conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  defp get_article(id) do
    Article
    |> Article.with_view_counts
    |> Repo.get!(id)
  end
end
