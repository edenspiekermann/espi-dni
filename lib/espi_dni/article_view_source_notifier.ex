defmodule EspiDni.ArticleViewSourceNotifier do

  @moduledoc """
  Determines if an article has view source spike and source a notification
  message
  """

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

  @doc """
  If the recent view counts are consider to be a view source spike, a
  notification is sent to the user
  """
  def notify_if_spike(article, team) do

    highest_sources = highest_sources(article)

    if source_spike?(highest_sources, team) do
      ArticleSlackMessenger.send_source_spike_message(article, hd(highest_sources))
    end
  end

  # Decides the recent views have triggered a source spike
  # source spike is:
  # All viewcounts are grouped by source
  # we compare the difference between the top two
  # if difference is >= than [x]
  # and top source is [x] % more than 2nd
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

  # return the count of the top two of view_counts for an article,
  # grouped by source
  # e.g. [%{count: 25, source: "Twitter} %{count: 10: source: "Facebook"}]
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
