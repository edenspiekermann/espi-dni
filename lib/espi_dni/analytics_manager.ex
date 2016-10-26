defmodule EspiDni.AnalyticsManager do

  require Logger
  alias EspiDni.GoogleAnalyticsClient

  def retrieve_anlaytics(team) do
    Logger.info "Retrieving analytics for team: #{team.id}"
    results = EspiDni.GoogleRealtimeClient.get_pageviews(team)

    for view_count_data <- results do
      EspiDni.ViewCountHandler.process_view_count(view_count_data, team)
    end

    active_articles = Article.recently_active(team)

    Logger.info "Notifying of any view_count spikes for team: #{team.id}"
    EspiDni.SpikeNotifier.notify_recent_spikes(team, active_articles)
  end
end
