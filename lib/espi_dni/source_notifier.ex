defmodule EspiDni.SpikeNotifier do
  require Logger
  alias EspiDni.Repo
  alias EspiDni.ViewCount
  alias EspiDni.Article
  import Ecto.Query

  @minimum_increase 2
  @increase_threshold_percentage 25

  def notify_if_source_spike(article, team) do
    highest_sources = highest_sources(article)

    if source_spike?(highest_sources, team) do
      send_source_message(article, hd(highest_sources))
    end
  end

  def source_spike?([highest_source, runner_up_source | _rest ], team) do
    difference              = highest_source.count - runner_up_source.count
    percentage_increase     = (highest_source.count / runner_up_source.count * 100)
    min_difference          = @minimum_increase
    min_percentage_increase = @increase_threshold_percentage

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

  defp send_source_message(article, source) do
    message = "Your article is seeing an increase in traffic to #{source.source}"

    case EspiDni.SlackWeb.send_message(article.user, message) do
      %{"ok" => true } -> {:ok, article.user}
      %{"ok" => false } -> {:error, article.user}
    end
  end
end
