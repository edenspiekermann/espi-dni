defmodule EspiDni.ArticleViewSourceNotifierTest do
  use ExUnit.Case
  alias EspiDni.ArticleViewSourceNotifier, as: Subject
  alias EspiDni.Team
  alias EspiDni.Repo
  import EspiDni.Factory

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    team    = insert(:team)
    user    = insert(:user, %{team: team})
    article = insert(:article, %{user: user})

    {:ok, team: team, article: article}
  end

  # if we send a message EspiDni.SlackWeb.send_message will return a tuple
  # for now just test that this is not nil, but I need to figure out the correct way
  # to test this

  test "notify_if_spike does not send a message if source minimum increase is not reached", %{team: team, article: article} do
    insert(:view_count, %{article_id: article.id, count: 2, source: "foo"})
    insert(:view_count, %{article_id: article.id, count: 5, source: "baz"})
    result = Subject.notify_if_spike(article, team)
    assert result == nil
  end

  test "notify_if_spike does not send message of percentage increase is not reached", %{team: team, article: article} do
    insert(:view_count, %{article_id: article.id, count: 500, source: "foo"})
    insert(:view_count, %{article_id: article.id, count: 550, source: "baz"})
    result = Subject.notify_if_spike(article, team)
    assert result == nil
  end

  test "notify_if_spike sends a message if the view source increase is a spike", %{team: team, article: article} do
    insert(:view_count, %{article_id: article.id, count: 2, source: "foo"})
    insert(:view_count, %{article_id: article.id, count: 24, source: "baz"})
    result = Subject.notify_if_spike(article, team)
    assert is_nil(result) == false
  end

end
