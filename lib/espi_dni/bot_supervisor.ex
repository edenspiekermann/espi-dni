defmodule EspiDni.BotSupervisor do

  @moduledoc """
  Manages Slack realtime connections to teams.
  Each team connection is created as a child process
  """

  use Supervisor
  require Logger
  alias EspiDni.SlackRtm

  @name EspiDni.BotSupervisor

  def start_link do
    Logger.info("Starting BotSupervisor")
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(SlackRtm, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  @doc """
  Starts child `EspiDni.SlackRtm` process which opens a websocket connection to
  connect a slackbot to a team using the provided token
  """
  def start_bot(token) do
    Logger.info("Starting bot via start_bot with token: #{token}")
    Supervisor.start_child(@name, [token])
  end
end
