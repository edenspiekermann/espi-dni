defmodule EspiDni.BotSupervisor do
  use Supervisor
  alias EspiDni.Repo
  alias EspiDni.Team
  alias EspiDni.SlackRtm

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = for team <- Repo.all(Team), do: worker(SlackRtm, [team.token])
    supervise(children, strategy: :one_for_one)
  end
end
