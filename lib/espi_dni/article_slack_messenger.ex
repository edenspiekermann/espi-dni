defmodule EspiDni.ArticleSlackMessenger do

  @moduledoc """
  Sends spike notifications to a user for their articles
  """

  alias EspiDni.{
    SlackWeb,
    Repo,
    NotificationMessage
  }
  import EspiDni.Gettext

  @doc """
  Sends a view spike message to an articles user
  """
  def send_view_spike_message(article, count_increase) do
    user    = article_user(article)
    message = view_spike_message(article, count_increase, user)

    send_message(user, message)
  end

  @doc """
  Sends a source spike message to an articles user
  """
  def send_source_spike_message(article, source) do
    user    = article_user(article)
    message = source_spike_message(article, source, user)

    send_message(user, message)
  end

  # Sends a custom view spike message if it exists
  # Otherwise selects a random pre-defined Gettext message
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

  # Returns a random view spike Gettext message
  defp view_spike_message(%{url: url}, count_increase) do
    string_number = :rand.uniform(6)

    Gettext.gettext(
      EspiDni.Gettext,
      "Message Spike #{string_number}",
      article_url: url,
      count: count_increase
    )
  end

  # Sends a custom view source spike message if it exists
  # Otherwise selects a random pre-defined Gettext message
  defp source_spike_message(%{url: url}, %{source: source}, user) do
    custom_text = get_custom_text(user.team_id, "source_spike")

    if is_nil(custom_text) do
      source_spike_message(%{url: url}, %{source: source})
    else
      case Gettext.Interpolation.interpolate(custom_text, %{article_url: url, source_name: source}) do
        {:ok, text} -> text
        _ -> source_spike_message(%{url: url}, %{source: source})
      end
    end
  end

  # Returns a random source spike Gettext message
  defp source_spike_message(%{url: url}, %{source: source}) do
    string_number = :rand.uniform(2)

    Gettext.gettext(
      EspiDni.Gettext,
      "Generic Source Spike #{string_number}",
      article_url: url,
      source_name: source
    )
  end

  # Returns a source spike message if the source is "Twitter"
  defp source_spike_message(%{url: url}, %{source: "Twitter"}) do
    gettext(
      "Twitter Source",
      article_url: url,
      article_search_url: url_without_protocol(url)
    )
  end

  # Returns a source spike message if the source is "Facebook"
  defp source_spike_message(%{url: url}, %{source: "Facebook"}) do
    gettext(
      "Facebook Source",
      article_url: url,
      article_search_url: url_without_protocol(url)
    )
  end

  defp article_user(article) do
    Repo.preload(article, :user).user
  end

  # Sends "message" to user using Slack API
  defp send_message(user, message) do
    case SlackWeb.send_message(user, message) do
      %{"ok" => true } -> {:ok, user}
      %{"ok" => false } -> {:error, user}
    end
  end

  # returns a url (and path) without protocol
  defp url_without_protocol(url) do
    parsed_url = URI.parse(url)
    parsed_url.host <> parsed_url.path
  end

  # returns a random Notification message of type 'type' for the `team_id`
  defp get_custom_text(team_id, type) do
    case NotificationMessage.random_message(team_id, type) do
      %NotificationMessage{text: custom_text} -> custom_text
      _ -> nil
    end
  end

end
