defmodule EspiDni.ViewCountHandlerTest do
  use EspiDni.ModelCase
  alias EspiDni.ViewCountHandler
  alias EspiDni.ViewCount
  alias EspiDni.Team

  setup do
    team = insert_team
    user = insert_user(team)
    article = insert_article(user)

    {:ok, team: team, article: article}
  end

  test "process_view_count creates a new viewcount for an existing article", %{team: team, article: article} do
    view_count_data = %{path: article.path, count: 42}
    ViewCountHandler.process_view_count(view_count_data, team)

    view_count = Repo.one(from view_count in ViewCount, order_by: [desc: view_count.id], limit: 1)
    assert view_count.count == 42
    assert view_count.article_id == article.id
  end

  test "process_view_count does not create a record for an unknown path", %{team: team} do
    view_count_data = %{path: "/unknown_path", count: 42}
    ViewCountHandler.process_view_count(view_count_data, team)
    assert Repo.one(from view_count in ViewCount, select: count(view_count.id)) == 0
  end

  test "process_view_count does not send message of min view count increase is not reached", %{team: team, article: article} do
    Repo.insert!(ViewCount.changeset(%ViewCount{}, %{article_id: article.id, count: 5}))
    view_count_data = %{path: article.path, count: 14}
    result = ViewCountHandler.process_view_count(view_count_data, team)
    assert result == nil
  end

  test "process_view_count does not send message of percentage increase is not reached", %{team: team, article: article} do
    Repo.insert!(ViewCount.changeset(%ViewCount{}, %{article_id: article.id, count: 500}))
    view_count_data = %{path: article.path, count: 20}
    result = ViewCountHandler.process_view_count(view_count_data, team)
    assert result == nil
  end

  test "process_view_count sends a message if the view count is a spike", %{team: team, article: article} do
    Repo.insert!(ViewCount.changeset(%ViewCount{}, %{article_id: article.id, count: 5}))
    view_count_data = %{path: article.path, count: 24}
    result = ViewCountHandler.process_view_count(view_count_data, team)

    # if we send a message EspiDni.SlackWeb.send_message will return a tuple
    # for now just test that this is not nil, but I need to figure out the correct way 
    # to test this
    assert is_nil(result) == false
  end

  test "process_view_count users team preferences for min views if set", %{team: team, article: article} do
    Repo.insert!(ViewCount.changeset(%ViewCount{}, %{article_id: article.id, count: 10}))
    team = Repo.update!(Team.changeset(team, %{min_view_count_increase: 2, view_count_threshold: 20}))
    view_count_data = %{path: article.path, count: 12}
    result = ViewCountHandler.process_view_count(view_count_data, team)

    assert is_nil(result) == false
  end
end
