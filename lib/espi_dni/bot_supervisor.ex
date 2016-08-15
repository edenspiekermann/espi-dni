defmodule EspiDni.BotSupervisor do
  use Supervisor
  alias EspiDni.Repo
  alias EspiDni.Team
  alias EspiDni.SlackRtm

  # A simple module attribute that stores the supervisor name
  @name EspiDni.BotSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_bot(token) do
    Supervisor.start_child(@name, worker(SlackRtm, [token]))
  end

  def init(:ok) do
    children = for team <- Repo.all(Team), do: worker(SlackRtm, [team.token], restart: :temporary)
    supervise(children, strategy: :one_for_one)
  end
end
