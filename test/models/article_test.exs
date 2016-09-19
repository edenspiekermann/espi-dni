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
end
