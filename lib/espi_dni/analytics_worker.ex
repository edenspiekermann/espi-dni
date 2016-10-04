defmodule EspiDni.AnalyticsWorker do
  use GenServer
  require Logger
  alias EspiDni.GooglePageViewClient
  alias EspiDni.ViewCountHandler
  import Ecto.Query, only: [from: 1, from: 2]

  @api_call_frequency_in_ms 1_800_000

  def start_link(team) do
    GenServer.start_link(__MODULE__, team, name: via_tuple(team))
  end

  def init(team) do
    Logger.info("Initializing AnalyticsWorker")
    queue_analytic_call(team)
  end

  defp via_tuple(team) do
    {:via, :gproc, {:n, :l, {:analytics_worker, team.name}}}
  end

  def queue_analytic_call(team) do
    Logger.info "Queueing analytic call for team: #{team.id} in #{@api_call_frequency_in_ms}ms"
    :timer.apply_after(5000, __MODULE__, :call_anlaytics, [team])
  end

  def call_anlaytics(team) do
    Logger.info "Retrieving analytics for team: #{team.id}"
    results = EspiDni.GoogleRealtimeClient.get_pageviews(team)

    for view_count_data <- results do
      EspiDni.ViewCountHandler.process_view_count(view_count_data, team)
    end

    queue_analytic_call(team)
  end
end
