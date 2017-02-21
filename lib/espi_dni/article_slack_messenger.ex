defmodule EspiDni.ArticleSlackMessenger do

  alias EspiDni.{
    SlackWeb,
    Repo,
    NotificationMessage
  }
  import EspiDni.Gettext

  def send_view_spike_message(article, count_increase) do
    user    = article_user(article)
    message = view_spike_message(article, count_increase, user)

    send_message(user, message)
  end

  def send_source_spike_message(article, source) do
    message = source_spike_message(article, source)
    user    = article_user(article)

    send_message(user, message)
  end

  defp view_spike_message(%{url: url}, count_increase, user) do
    custom_text = get_custom_text(user.team_id, "view_count_spike")

    if is_nil(custom_text) do
      view_spike_message(%{url: url}, count_increase)
    else
      case Gettext.Interpolation.interpolate(custom_text, %{article_url: url, count: count_increase}) do
        {:ok, text} -> text
        _ -> view_spike_message(%{url: url}, count_increase)
      end
    end
  end

  defp view_spike_message(%{url: url}, count_increase) do
    string_number = :rand.uniform(6)

    Gettext.gettext(
      EspiDni.Gettext,
      "Message Spike #{string_number}",
      article_url: url,
      count: count_increase
    )
  end

  defp get_custom_text(team_id, type) do
    case NotificationMessage.random_message(team_id, type) do
      %NotificationMessage{text: custom_text} -> custom_text
      _ -> nil
    end
  end

  defp source_spike_message(%{url: url}, %{source: "Twitter"}) do
    gettext(
      "Twitter Source",
      article_url: url,
      article_search_url: url_without_protocol(url)
    )
  end

  defp source_spike_message(%{url: url}, %{source: "Facebook"}) do
    gettext(
      "Facebook Source",
      article_url: url,
      article_search_url: url_without_protocol(url)
    )
  end

  defp source_spike_message(%{url: url}, %{source: source}) do
    string_number = :rand.uniform(2)

    Gettext.gettext(
      EspiDni.Gettext,
      "Generic Source Spike #{string_number}",
      article_url: url,
      source_name: source
    )
  end

  defp article_user(article) do
    Repo.preload(article, :user).user
  end

  defp send_message(user, message) do
    case SlackWeb.send_message(user, message) do
      %{"ok" => true } -> {:ok, user}
      %{"ok" => false } -> {:error, user}
    end
  end

  defp url_without_protocol(url) do
    parsed_url = URI.parse(url)
    parsed_url.host <> parsed_url.path
  end

end
