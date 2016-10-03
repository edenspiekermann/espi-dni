defmodule EspiDni.ViewCountHandler do

  require Logger
  alias EspiDni.Repo
  alias EspiDni.ViewCount
  import EspiDni.Gettext
  import Ecto.Query

  @minimum_increase 10
  @increase_threshold_percentage 25

  def process_view_count(view_count_data, team) do
    article = get_article(view_count_data.path, team)

    case create_view_count(article, view_count_data) do
      {:ok, _} ->
        notify_if_count_spike(article, team)
      {:error, changeset} ->
        Logger.error "Cannot create view_count: #{inspect changeset}"
      _ ->
        nil
    end
  end

  defp notify_if_count_spike(article, team) do
    latest_counts = last_two_counts(article)

    if view_count_spike?(latest_counts, team) do
      send_spike_message(article,latest_counts)
    end
  end

  def send_spike_message(article, latest_counts) do
    message =  gettext("Message Spike", %{article_url: article.url, count: hd(latest_counts)})

    case EspiDni.SlackWeb.send_message(article.user, message) do
      %{"ok" => true } -> {:ok, article.user}
      %{"ok" => false } -> {:error, article.user}
    end
  end

  defp view_count_spike?([current_count | [previous_count]], team) do
    difference              = current_count - previous_count
    percentage_increase     = (difference / previous_count * 100)
    min_difference          = team.min_view_count_increase || @minimum_increase
    min_percentage_increase = team.view_count_threshold || @increase_threshold_percentage

    (difference >= min_difference) && (percentage_increase >= min_percentage_increase)
  end

  # return false if there's not a list with two entries
  defp view_count_spike?(_, team), do: false

  defp create_view_count(nil, _), do: :nil

  defp create_view_count(article, view_count_data) do
    ViewCount.changeset(%ViewCount{}, %{article_id: article.id, count: view_count_data.count})
    |> Repo.insert()
  end

  defp get_article(path, team) do
    Repo.one(
      from article in EspiDni.Article,
      join: user in EspiDni.User, on: user.id == article.user_id,
      where: user.team_id == ^team.id,
      where: article.path == ^path,
      preload: :user
    )
  end

  defp last_two_counts(article) do
    Repo.all(
      from view_count in ViewCount,
      select: view_count.count,
      where: view_count.article_id == ^article.id,
      order_by: [desc: view_count.id],
      limit: 2
    )
  end
end
