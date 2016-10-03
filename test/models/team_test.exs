defmodule EspiDni.TeamTest do
  use EspiDni.ModelCase

  alias EspiDni.Team

  @valid_attrs %{
    name: "somename",
    slack_id: "some content",
    slack_token: "some content",
    url: "some content"
  }
  @invalid_attrs %{}

  setup do
    team = insert_team
    user = insert_user(team)
    {:ok, team: team, user: user}
  end

  test "changeset with valid attributes" do
    changeset = Team.changeset(%Team{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Team.changeset(%Team{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "article_paths with no articles", %{team: team} do
    assert Team.article_paths(team) == []
  end

  test "article_paths with articles", %{team: team, user: user} do
    insert_article(user, %{url: "http://f.com/foobar", path: "/foobar"})
    insert_article(user, %{url: "http://f.com/", path: "/"})
    insert_article(user, %{url: "http://f.com/baz/bar", path: "/foo/baz/bar/"})
    assert Enum.sort(Team.article_paths(team)) == Enum.sort(["/foobar", "/", "/foo/baz/bar/"])
  end
end
