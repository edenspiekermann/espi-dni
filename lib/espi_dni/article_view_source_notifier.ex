defmodule EspiDni.ArticleViewSourceNotifier do

  import Ecto.Query
  alias EspiDni.{
    Repo,
    ViewCount,
    SlackWeb,
    ArticleSlackMessenger
  }
  require Logger

  @minimum_increase 10
  @increase_threshold_percentage 20

  def notify_if_spike(article, team) do
    highest_sources = highest_sources(article)

    if source_spike?(highest_sources, team) do
      ArticleSlackMessenger.send_source_spike_message(article, hd(highest_sources))
    end
  end

  def source_spike?([highest_source, runner_up_source | _rest ], team) do
    difference              = highest_source.count - runner_up_source.count
    percentage_increase     = (difference / runner_up_source.count * 100)
    min_difference          = team.min_source_count_increase || @minimum_increase
    min_percentage_increase = team.source_count_threshold || @increase_threshold_percentage

    (difference >= min_difference) && (percentage_increase >= min_percentage_increase)
  end

  # return false if there's not a list with two entries
  def source_spike?(_, team) do
    Logger.info("No enough view counts returned for source notification check")
    false
  end

  defp highest_sources(article) do
    Repo.all(
      from view_count in ViewCount,
      select: %{
        count: sum(view_count.count),
        source: view_count.source
      },
      where: view_count.article_id == ^article.id,
      where: not is_nil(view_count.source),
      where: view_count.source != "(direct)",
      group_by: view_count.source,
      order_by: [desc: sum(view_count.count)], 
      limit: 2
    )
  end

end
