defmodule EspiDni.SpikeNotifier do
  require Logger
  alias EspiDni.Repo
  alias EspiDni.ViewCount
  alias EspiDni.Article
  import Ecto.Query

  @minimum_increase 10
  @increase_threshold_percentage 25

  def notify_recent_spikes(team, active_articles) do
    for article <- active_articles do
      notify_if_count_spike(article, team)
    end
  end

  def notify_if_count_spike(article, team) do
    latest_counts = last_two_counts(article)

    if view_count_spike?(latest_counts, team) do
      send_spike_message(article, latest_counts)
    end
  end

  defp last_two_counts(article) do
    Repo.all(
      from view_count in ViewCount,
      select: sum(view_count.count),
      where: view_count.article_id == ^article.id,
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

  defp send_spike_message(article, latest_counts) do
    message = spike_message(article, latest_counts)

    case EspiDni.SlackWeb.send_message(article.user, message) do
      %{"ok" => true } -> {:ok, article.user}
      %{"ok" => false } -> {:error, article.user}
    end
  end

  defp spike_message(%{url: url}, [current_count | [previous_count]]) do
    string_number = :rand.uniform(6)
    count = current_count - previous_count

    Gettext.gettext(
      EspiDni.Gettext,
      "Message Spike #{string_number}",
      article_url: url,
      count: count
    )
  end
end
