defmodule EspiDni.TeamTest do
  use EspiDni.ModelCase

  alias EspiDni.Team

  @valid_attrs %{
    name: "somename",
    slack_id: "some content",
    token: "some content",
    url: "some content"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Team.changeset(%Team{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Team.changeset(%Team{}, @invalid_attrs)
    refute changeset.valid?
  end
end
