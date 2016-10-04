defmodule EspiDni.AnalyticsSupervisor do

  require Logger
  use Supervisor
  alias EspiDni.AnalyticsWorker
  import Ecto.Query, only: [from: 1, from: 2]

  @name EspiDni.AnalyticsSupervisor

  def start_link do
    Logger.info("Starting AnalyticsSupervisor")
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(EspiDni.AnalyticsWorker, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def start_anlaytics_worker(team) do
    Logger.info("Starting analytic worker via start_anlaytics_worker for team: #{team.id}")
    Supervisor.start_child(@name, [team])
  end
end
