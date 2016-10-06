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

  describe "current_state" do
    test "reuturns :new for a new team" do
      assert Team.current_state(%Team{}) == :new
    end

    test "returns :awaiting_google_token for a team with a slack token" do
      team = %Team{slack_token: "token"}
      assert Team.current_state(team) == :awaiting_google_token
    end

    test "returns :awaiting_google_property for a team with a slack and google token" do
      team = %Team{slack_token: "token", google_token: "token"}
      assert Team.current_state(team) == :awaiting_refresh_token
    end

    test "returns :awaiting_refresh_token for a team with a slack, google and refresh token" do
      team = %Team{slack_token: "slack", google_token: "google", google_refresh_token: "refresh"}
      assert Team.current_state(team) == :awaiting_google_property
    end

    test "returns :complete for a team with all necessary data" do
      team = %Team{slack_token: "slack", google_token: "google", google_refresh_token: "refresh", google_property_id: "123"}
      assert Team.current_state(team) == :complete
    end
  end
end
