defmodule EspiDni.ViewCountHandlerTest do
  use EspiDni.ModelCase
  alias EspiDni.ViewCountHandler
  alias EspiDni.ViewCount

  setup do
    team = insert_team
    user = insert_user(team)
    article = insert_article(user)

    {:ok, team: team, article: article}
  end

  test "process_view_count creates a new viewcount for an existing article", %{team: team, article: article} do
    view_count_data = %{path: article.path, count: 42, source: "google"}
    ViewCountHandler.process_view_count(view_count_data, team)

    view_count = Repo.one(from view_count in ViewCount, order_by: [desc: view_count.id], limit: 1)
    assert view_count.count == 42
    assert view_count.article_id == article.id
    assert view_count.source == "google"
  end

  test "process_view_count does not create a record for an unknown path", %{team: team} do
    view_count_data = %{path: "/unknown_path", count: 42}
    ViewCountHandler.process_view_count(view_count_data, team)
    assert Repo.one(from view_count in ViewCount, select: count(view_count.id)) == 0
  end
end
