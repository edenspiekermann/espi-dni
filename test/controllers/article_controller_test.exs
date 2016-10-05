defmodule EspiDni.ArticleControllerTest do
  use EspiDni.ConnCase

  alias EspiDni.Article
  @valid_attrs %{url: "http://www.example.com"}
  @invalid_attrs %{url: "invalid"}

  setup do
    team = insert_team
    user = team |> insert_user
    article = user |> insert_article

    conn =
      build_conn
      |> assign(:current_user, user)
      |> assign(:current_team, team)

    {:ok, conn: conn, article: article, team: team, user: user}
  end

  test "requires user authentication on all actions" do
    conn = build_conn
    Enum.each([
      get(conn, article_path(conn, :new)),
      get(conn, article_path(conn, :index)),
      get(conn, article_path(conn, :show, "123")),
      get(conn, article_path(conn, :edit, "123")),
      put(conn, article_path(conn, :update, "123", %{})),
      post(conn, article_path(conn, :create, %{})),
      delete(conn, article_path(conn, :delete, "123")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_path(conn, :index)
    assert html_response(conn, 200) =~ "Your Articles"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, article_path(conn, :new)
    assert html_response(conn, 200) =~ "New article"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, article_path(conn, :create), article: @valid_attrs
    assert redirected_to(conn) == article_path(conn, :index)
    assert Repo.get_by(Article, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, article_path(conn, :create), article: @invalid_attrs
    assert html_response(conn, 200) =~ "New article"
  end

  test "renders form for editing chosen resource", %{conn: conn, article: article} do
    conn = get conn, article_path(conn, :edit, article)
    assert html_response(conn, 200) =~ "Edit article"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, article: article} do
    conn = put conn, article_path(conn, :update, article), article: @valid_attrs
    assert redirected_to(conn) == article_path(conn, :show, article)
    assert Repo.get_by(Article, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, article: article} do
    conn = put conn, article_path(conn, :update, article), article: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit article"
  end

  test "deletes chosen resource", %{conn: conn, article: article} do
    conn = delete conn, article_path(conn, :delete, article)
    assert redirected_to(conn) == article_path(conn, :index)
    refute Repo.get(Article, article.id)
  end
end
