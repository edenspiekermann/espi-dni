defmodule EspiDni.GoogleAnalyticsClient do

  require Logger
  alias EspiDni.GoogleWebProperty

  @url "https://www.googleapis.com/analytics/v3/management/accounts"
  @account_id "~all"
  @properties_path "/webproperties"
  @headers []

  def get_properties(team) do
    case HTTPoison.get(@url, @headers, params: request_params(team)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        parse_properties(response)
      {:ok, %HTTPoison.Response{status_code: 401, body: response}} ->
        Logger.error "Authentication error #{inspect response}"
        []
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Google Analytics error #{inspect reason}"
        []
    end
  end

  defp parse_properties(response) do
    case Poison.decode(response, as: %{"items" => [%GoogleWebProperty{}]}) do
      {:ok, %{"items" => items}} -> items
      _ -> []
    end
  end

  defp request_params(team) do
    %{"access_token" => team.google_token}
  end

  defp web_properties_url do
    @url <> @account_id <> @properties_path
  end
end
