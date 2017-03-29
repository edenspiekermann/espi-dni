defmodule EspiDni.AnalyticsManager do

  @moduledoc """
  A module that retrieves analytics for a team and sends notifications if
  the anlalytics retrieve have caused a spike
  """

  require Logger
  alias EspiDni.{
    GoogleRealtimeClient,
    ViewCountHandler,
    Article,
    ArticleViewCountNotifier,
    ArticleViewSourceNotifier
  }

  @doc """
  Makes a call to Google anlaytics using GoogleRealtimeClient to get the recent
  pageviews for all articles belonging to a team.

  The viewcounts retrieved from google analytics are the processed, and saved
  if the correspondning article is found.

  Once all the viewcounts have been processed, the recently_active articles
  (articles that have recieved view_counts in the past 2 hours) are analysed
  to see if there has been a spike and a notification is sent accordingly
  """
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
