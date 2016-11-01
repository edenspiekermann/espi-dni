defmodule EspiDni.ArticleSlackMessenger do

  alias EspiDni.{
    SlackWeb,
    Repo
  }

  def send_view_spike_message(article, latest_counts) do
    message = view_spike_message(article, latest_counts)
    user    = article_user(article)

    case SlackWeb.send_message(user, message) do
      %{"ok" => true } -> {:ok, user}
      %{"ok" => false } -> {:error, user}
    end
  end

  defp view_spike_message(%{url: url}, [current_count | [previous_count]]) do
    string_number = :rand.uniform(6)
    count = current_count - previous_count

    Gettext.gettext(
      EspiDni.Gettext,
      "Message Spike #{string_number}",
      article_url: url,
      count: count
    )
  end

  defp article_user(article) do
    Repo.preload(article, :user).user
  end

end
