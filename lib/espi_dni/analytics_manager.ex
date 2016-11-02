defmodule EspiDni.AnalyticsManager do

  require Logger
  alias EspiDni.{
    GoogleRealtimeClient,
    ViewCountHandler,
    Article,
    ArticleViewCountNotifier,
    ArticleViewSourceNotifier
  }

  def retrieve_anlaytics(team) do
    Logger.info "Retrieving analytics for team: #{team.id}"
    results = GoogleRealtimeClient.get_pageviews(team)

    for view_count_data <- results do
      ViewCountHandler.process_view_count(view_count_data, team)
    end

    Logger.info "Checking for source and view spikes for team: #{team.id}"
    for article <- Article.recently_active(team) do
      ArticleViewCountNotifier.notify_if_spike(article, team)
      ArticleViewSourceNotifier.notify_if_spike(article, team)
    end
  end
end
