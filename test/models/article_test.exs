defmodule EspiDni.ArticleTest do
  use EspiDni.ModelCase

  alias EspiDni.Article

  @valid_attrs %{url: "http://www.example.com/foo"}
  @invalid_attrs %{url: "not a url"}

  test "changeset with valid attributes" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Article.changeset(%Article{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with url missing" do
    changeset = Article.changeset(%Article{}, %{})
    refute changeset.valid?
  end
end
