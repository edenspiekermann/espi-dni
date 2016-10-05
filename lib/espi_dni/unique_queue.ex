defmodule EspiDni.UniqueQueue do
  alias EspiDni.Team

  @queue "default"

  def enqueue_in(worker, team, seconds) do
    unless is_already_scheduled?(worker, team) do
      Exq.enqueue_in(Exq, @queue, seconds, worker, [Integer.to_string(team.id)])
    end
  end

  defp is_already_scheduled?(worker, %Team{id: id}) do
    {:ok, scheduled_jobs} = Exq.Api.scheduled(Exq.Api)

    team_id = Integer.to_string(id)
    name = worker_name(worker)

    Enum.find(
      scheduled_jobs,
      &match?(%{class: ^name, args: [^team_id], queue: "default"}, &1)
    ) |> is_nil
      |> Kernel.not
  end

  defp worker_name(module_name) do
    Atom.to_string(module_name)
    |> String.replace(~r/\AElixir./, "")
  end

end
