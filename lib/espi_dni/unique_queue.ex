defmodule EspiDni.UniqueQueue do

  @moduledoc """
  Adds jobs to an Exq queure only the they are not already queued
  """
  alias EspiDni.Team

  @queue "default"

  @doc """
  Adds a job to be run in the future, only if an identical jobs is not already
  queued
  worker: the Module to perform the job
  team: the team the job is for
  seconds: how many seconds into the future the jobs should be performed
  """
  def enqueue_in(worker, team, seconds) do
    unless is_already_scheduled?(worker, team) do
      Exq.enqueue_in(Exq, @queue, seconds, worker, [Integer.to_string(team.id)])
    end
  end

  # Checks if a job already exists in the queue for the worker and team_id
  # specified
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
    module_name
    |> Atom.to_string
    |> String.replace(~r/\AElixir./, "")
  end

end
