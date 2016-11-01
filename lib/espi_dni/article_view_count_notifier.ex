defmodule EspiDni.ArticleViewCountNotifier do

  require Logger
  import Ecto.Query
  alias EspiDni.{
    Repo,
    ViewCount,
    Article,
    ArticleSlackMessenger
  }

  @minimum_increase 10
  @increase_threshold_percentage 25

  def notify_if_spike(article, team) do
    latest_counts = last_two_counts(article)

    if view_count_spike?(latest_counts, team) do
      ArticleSlackMessenger.send_view_spike_message(article, latest_counts)
    end
  end

  defp last_two_counts(article) do
    Repo.all(
      from view_count in ViewCount,
      select: sum(view_count.count),
      where: view_count.article_id == ^article.id,
      where: view_count.inserted_at > ago(2, "hour"),
      group_by: fragment("round(extract('epoch' from inserted_at) / 1800)"),
      order_by: fragment("round(extract('epoch' from inserted_at) / 1800) desc"),
      limit: 2
    )
  end

  defp view_count_spike?([current_count | [previous_count]], team) do
    difference              = current_count - previous_count
    percentage_increase     = (difference / previous_count * 100)
    min_difference          = team.min_view_count_increase || @minimum_increase
    min_percentage_increase = team.view_count_threshold || @increase_threshold_percentage

    (difference >= min_difference) && (percentage_increase >= min_percentage_increase)
  end

  # return false if there's not a list with two entries
  defp view_count_spike?(_, _team), do: false

end
