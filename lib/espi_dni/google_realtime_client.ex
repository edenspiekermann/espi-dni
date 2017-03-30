defmodule EspiDni.GoogleRealtimeClient do

  @moduledoc """
  A module for dealing with Google's realtime API
  """

  require Logger

  @metrics "rt:pageviews"
  @page_path "rt:pagePath"
  @page_source "rt:source"
  @dimensions "rt:pagePath, rt:source"
  @url "https://www.googleapis.com/analytics/v3/data/realtime"

  @doc """
  Returns pageviews for a team. Returns a colletion of page views for a team
  Returns view counts in the format:
  [%{path: "/foo/article/1", source: "Twitter", count: 42},
  [%{path: "/foo/article/1", source: "Google", count: 24},
  %{path: "/foo/article/2", source: "Google", count: 12}]
  """
  def get_pageviews(team) do
    case HTTPoison.get(@url, [], params: request_params(team)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        parse_pageviews(response)
      {:ok, %HTTPoison.Response{status_code: 401, body: response}} ->
        Logger.error "Authentication error #{inspect response}"
        []
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Google Realtime Analytics error #{inspect reason}"
        []
    end
  end

  @doc """
  The google API request parameters
  ids: the teams's web property to be used for the API call
  metrics: the metrics to be queried - viewcounts
  dimesnsions: the details we want the metrics to be grouped by - path + source
  access_token: the teams google oauth2 token
  filters: a query param containing all the paths of articles belonging to
  the team - we only want results for articles the user has entered
  """
  def request_params(team) do
    %{
      "ids" => "ga:#{team.google_property_id}",
      "metrics" => @metrics,
      "dimensions" => @dimensions,
      "access_token" => team.google_token,
      "filters" => filters(team)
    }
  end

  # Returns a filter string for all team articles, in the format:
  # rt:pagePath=~[article_path] joined by ','
  # e.g. rt:pagePath=~/foo/bar-1/,rt:pagePath=~/foo/bar-2/
  defp filters(team) do
    EspiDni.Team.article_paths(team)
    |> Enum.map(&"rt:pagePath==#{&1}")
    |> Enum.join(",")
  end

  # Parses the JSON response, and extacts the results (if any)
  # into structs
  defp parse_pageviews(response) do
    case Poison.decode!(response) do
      %{"columnHeaders" => headers, "rows" => rows} ->
        Enum.map(rows, fn(row) ->
          parse_viewcount(headers, row)
        end)
      %{"columnHeaders" => headers} ->
        Logger.info "No view count data found."
        []
      _ ->
        Logger.error "Pageview response in unexpected format: #{inspect response}"
        []
    end
  end

  defp parse_viewcount(headers, row) do
    %{
      path: get_data(headers, row, @page_path),
      source: get_data(headers, row, @page_source),
      count: get_data(headers, row, @metrics)
    }
  end

  # uses he collection of headers to figure out he index of he result for a key
  defp get_data(headers, rows, key) do
    Enum.at(rows, key_column_index(headers, key))
  end

  # returns the column index for a key
  defp key_column_index(columns, key) do
    Enum.find_index(columns, fn(column) -> Map.get(column, "name") == key end)
  end

end
