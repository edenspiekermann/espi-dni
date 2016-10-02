defmodule EspiDni.ArticleTest do
  use EspiDni.ModelCase

  alias EspiDni.Article

  @valid_attrs %{url: "http://www.example.com/foo?param=bar", user_id: 123}
  @invalid_attrs %{url: "not a url"}

  test "changeset with valid attributes" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changset sets the article path" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert get_change(changeset, :path) == "/foo"
  end

  test "changset sets the article path for a root url" do
    changeset = Article.changeset(%Article{}, %{url: "http://www.example.com"})
    assert get_change(changeset, :path) == "/"
  end

  test "changeset with invalid attributes" do
    changeset = Article.changeset(%Article{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with url missing is invalid" do
    changeset = Article.changeset(%Article{}, %{})
    refute changeset.valid?
  end

  describe "with a pre-existing article" do
    setup do
      team = insert_team
      article = team |> insert_user |> insert_article(%{path: "/foobar"})

      {:ok, team: team, article: article}
    end

    test "changeset with a duplicate url", %{team: team, article: article} do
      changeset = Article.changeset(%Article{}, %{team_id: team.id, user_id: article.user_id, url: article.url})
      result = Repo.insert(changeset)
      {response_code, response_changeset} = result
      assert response_code == :error
      hd(response_changeset.constraints).constraint == "unique_user_article"
    end

    test "changeset with a different url", %{team: team, article: article} do
      changeset = Article.changeset(%Article{}, %{team_id: team.id, user_id: article.user_id, url: "http://www.example.com/different"})
      result = Repo.insert(changeset)
      {response_code, response_changeset} = result

      assert response_code == :ok
    end

    test "changeset with a duplicate url but a differet user", %{team: team, article: article} do
      user = insert_user(team)
      changeset = Article.changeset(%Article{}, %{team_id: team.id, user_id: user.id, url: article.url})
      result = Repo.insert(changeset)
      {response_code, response_changeset} = result

      assert response_code == :ok
    end
  end
end
