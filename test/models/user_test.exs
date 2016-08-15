defmodule EspiDni.UserTest do
  use EspiDni.ModelCase

  alias EspiDni.User

  @valid_attrs %{email: "some content", name: "some content", slack_id: "some content", timezone: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
