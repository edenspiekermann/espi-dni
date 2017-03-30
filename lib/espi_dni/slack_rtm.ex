defmodule EspiDni.SlackRtm do

  @moduledoc """
  A module for dealing with Slacks Realtime Messaging API
  Uses https://github.com/BlakeWilliams/Elixir-Slack
  """

  use Slack
  require Logger

  @token Application.get_env(:espi_dni, __MODULE__)[:slack_token]

  def start_link, do: start_link(@token)

  @doc """
  Called when an connection is made
  """
  def handle_connect(slack) do
    Logger.info "Connected as #{slack.me.name}"
  end

  @doc """
  Called when a message is received
  """
  def handle_message(message = %{type: "message"}, slack) do
    if message.user != slack.me.id do
      Logger.debug "Message received: #{slack.me.name}"
    end
  end

  @doc """
  Called when any other (not an message) Slack activity is received
  """
  def handle_message(message, _slack) do
    Logger.debug "Received slack activity: #{inspect message}"
  end

  @doc """
  Called when a realtime message is being sent
  """
  def handle_info({:message, text, channel}, slack) do
    Logger.info "Sending your message: #{text}"
    send_message(text, channel, slack)
    {:ok}
  end
  def handle_info(_, _), do: :ok

end
