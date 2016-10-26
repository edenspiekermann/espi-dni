defmodule EspiDni.SpikeNotifierTest do
  use ExUnit.Case
  import EspiDni.Factory
  alias EspiDni.SpikeNotifier
  alias EspiDni.Team
  alias EspiDni.Repo

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

  test "notify_if_count_spike does not send message of min view count increase is not reached", %{team: team, article: article} do
    insert_previous_view_count(%{article_id: article.id, count: 5})
    insert(:view_count, %{article_id: article.id, count: 5})
    result = SpikeNotifier.notify_if_count_spike(article, team)
    assert result == nil
  end

  test "notify_if_count_spike does not send message of percentage increase is not reached", %{team: team, article: article} do
    insert_previous_view_count(%{article_id: article.id, count: 500})
    insert(:view_count, %{article_id: article.id, count: 20})
    result = SpikeNotifier.notify_if_count_spike(article, team)
    assert result == nil
  end

  test "notify_if_count_spike sends a message if the view count is a spike", %{team: team, article: article} do
    insert_previous_view_count(%{article_id: article.id, count: 5})
    insert(:view_count, %{article_id: article.id, count: 24})
    result = SpikeNotifier.notify_if_count_spike(article, team)
    assert is_nil(result) == false
  end

  test "process_view_count users team preferences for min views if set", %{team: team, article: article} do
    insert_previous_view_count(%{article_id: article.id, count: 10})
    team = Repo.update!(Team.changeset(team, %{min_view_count_increase: 2, view_count_threshold: 20}))
    insert(:view_count, %{article_id: article.id, count: 12})
    result = SpikeNotifier.notify_if_count_spike(article, team)
    assert is_nil(result) == false
  end
end
