defmodule EspiDni.ArticleSlackMessenger do

  alias EspiDni.{
    SlackWeb,
    Repo
  }

  def send_view_spike_message(article, count_increase) do
    message = view_spike_message(article, count_increase)
    user    = article_user(article)

    send_message(user, message)
  end

  def send_source_spike_message(article, source) do
    message = "Your article is seeing an increase in traffic from #{source.source}"
    user    = article_user(article)

    send_message(user, message)
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

  defp source_spike_message(%{url: url}, %{source: source}) do
    "Your article is seeing an increase in traffic from #{source.source}"
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

end
