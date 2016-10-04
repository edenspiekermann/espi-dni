defmodule EspiDni.TokenSupervisor do

  require Logger
  use Supervisor
  alias EspiDni.TokenWorker

  @name EspiDni.TokenSupervisor

  def start_link do
    Logger.info("Starting TokenSupervisor")
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(TokenWorker, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def start_token_worker(team) do
    Logger.info("Starting token worker via start_token_worker for team: #{team.id}")
    Supervisor.start_child(@name, [team])
  end
end
