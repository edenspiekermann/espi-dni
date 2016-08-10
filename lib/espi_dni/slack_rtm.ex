defmodule EspiDni.SlackRtm do
  use Slack

  @token Application.get_env(:espi_dni, __MODULE__)[:slack_token]

  def start_link, do: start_link(@token)

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end

  def handle_message(message = %{type: "message"}, slack) do
    if message.user != slack.me.id do
      send_message("I got a message!", message.channel, slack)
    end
  end

  def handle_message(message = %{type: "message"}, slack) do
    send_message("I got a message!", message.channel, slack)
  end

  def handle_message(message, _slack) do
    IO.inspect(message)
  end

  def handle_info({:message, text, channel}, slack) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok}
  end
  def handle_info(_, _), do: :ok

end
