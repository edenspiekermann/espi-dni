defmodule EspiDni.ViewCountTest do
  use EspiDni.ModelCase

  alias EspiDni.ViewCount

  @valid_attrs %{count: 42, article_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ViewCount.changeset(%ViewCount{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ViewCount.changeset(%ViewCount{}, @invalid_attrs)
    refute changeset.valid?
  end
end
