defmodule EspiDni.GoogleRealtimeClient do

  require Logger
  import Ecto.Query, only: [from: 1, from: 2]
  alias EspiDni.ViewCount
  alias EspiDni.Repo

  @metrics "rt:pageviews"
  @dimensions "rt:pagePath"
  @url "https://www.googleapis.com/analytics/v3/data/realtime"

  def get_pageviews(team) do
    case HTTPoison.get(@url, [], params: request_params(team)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        parse_pageviews(response, team)
      {:ok, %HTTPoison.Response{status_code: 401, body: response}} ->
        Logger.error "Authentication error #{inspect response}"
        []
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Google Realtime Analytics error #{inspect reason}"
        []
    end
  end

  def request_params(team) do
    %{
      "ids" => "ga:#{team.google_property_id}",
      "metrics" => @metrics,
      "dimensions" => @dimensions,
      "access_token" => team.google_token,
      "filters" => filters(team)
    }
  end

  @doc """
  Returns a filter string for all team articles, in the format:
  rt:pagePath=~[article_path] joined by ','

  e.g. rt:pagePath=~/foo/bar-1/,rt:pagePath=~/foo/bar-2/
  """
  defp filters(team) do
    EspiDni.Team.article_paths(team)
    |> Enum.map(&"rt:pagePath==#{&1}")
    |> Enum.join(",")
  end

  defp parse_pageviews(response, team) do
    case Poison.decode!(response) do
      %{"columnHeaders" => headers, "rows" => rows} ->
        Enum.map(rows, fn(row) ->
          parse_viewcount(headers, row, team)
        end)
      _ -> []
    end
  end

  defp parse_viewcount(headers, row, team) do
    %{
      path: get_data(headers, row, @dimensions),
      count: get_data(headers, row, @metrics)
    }
  end

  defp get_data(headers, rows, key) do
    Enum.at(rows, key_column_index(headers, key))
  end

  defp key_column_index(columns, key) do
    Enum.find_index(columns, fn(column) -> Map.get(column, "name") == key end)
  end

end
