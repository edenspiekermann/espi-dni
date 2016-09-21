defmodule EspiDni.SlackRtm do
  use Slack
  require Logger

  @token Application.get_env(:espi_dni, __MODULE__)[:slack_token]

  def start_link, do: start_link(@token)

  def handle_connect(slack) do
    Logger.info "Connected as #{slack.me.name}"
  end

  def handle_message(message = %{type: "message"}, slack) do
    if message.user != slack.me.id do
      Logger.info "Message received: #{slack.me.name}"
    end
  end

  def handle_message(message, _slack) do
    Logger.info "Received slack activity: #{message}"
  end

  def handle_info({:message, text, channel}, slack) do
    Logger.info "Sending your message: #{text}"
    send_message(text, channel, slack)
    {:ok}
  end
  def handle_info(_, _), do: :ok

end
