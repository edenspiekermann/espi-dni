defmodule EspiDni.GoogleAnalyticsClient do

  require Logger
  alias EspiDni.GoogleWebProperty

  @base_url "https://www.googleapis.com"
  @token_refresh_path "/oauth2/v4/token"
  @url "https://www.googleapis.com/analytics/v3/management/accounts"
  @account_id "~all"
  @properties_path "/webproperties"
  @client_id Application.get_env(:ueberauth, Ueberauth.Strategy.Google.OAuth)[:client_id]
  @client_secret Application.get_env(:ueberauth, Ueberauth.Strategy.Google.OAuth)[:client_secret]

  def get_properties(team) do
    case HTTPoison.get(@url, [], params: request_params(team)) do
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

  def get_new_token(team) do
    case HTTPoison.post(refresh_token_url, { :form, refresh_form(team)}) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        parse_token(response)
      {:ok, %HTTPoison.Response{status_code: 401, body: response}} ->
        Logger.error "Authentication error #{inspect response}"
        []
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Google Analytics error #{inspect reason}"
        []
    end
  end

  defp parse_properties(response) do
    case Poison.decode!(response, as: %{"items" => [%GoogleWebProperty{}]}) do
      {:ok, %{"items" => items}} -> items
      _ -> []
    end
  end

  defp parse_token(response) do
    case Poison.decode!(response) do
      %{"access_token" => access_token} -> access_token
      _ -> []
    end
  end

  defp request_params(team) do
    %{"access_token" => team.google_token}
  end

  defp refresh_form(team) do
    [
      refresh_token: team.google_refresh_token,
      client_id: @client_id,
      client_secret: @client_secret,
      grant_type: "refresh_token"
    ]
  end

  defp web_properties_url do
    @url <> @account_id <> @properties_path
  end

  defp refresh_token_url do
    @base_url <> @token_refresh_path
  end
end
