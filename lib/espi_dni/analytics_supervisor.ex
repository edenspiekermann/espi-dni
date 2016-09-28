defmodule EspiDni.AnalyticsSupervisor do
  use GenServer
  use Supervisor
  require Logger
  alias EspiDni.Team
  alias EspiDni.ViewCount
  alias EspiDni.Repo
  alias EspiDni.GooglePageViewClient
  import Ecto.Query, only: [from: 1, from: 2]

  @api_call_frequency_in_ms 1_800_000

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    for team <- teams_with_analytics_configs do
      queue_analytic_call(team)
    end
    {:ok, IO.puts "queued analytics" }
  end

  def queue_analytic_call(team) do
    Logger.info "Queueing analytic call for team: #{team.id} in #{@api_call_frequency_in_ms}ms"
    :timer.apply_after(@api_call_frequency_in_ms, __MODULE__, :call_anlaytics, [team])
  end

  def call_anlaytics(team) do
    Logger.info "Retrieving analytics for team: #{team.id}"
    results = EspiDni.GoogleRealtimeClient.get_pageviews(team)

    for view_count_data <- results do
      create_view_count(view_count_data, team)
    end

    queue_analytic_call(team)
  end

  defp teams_with_analytics_configs do
    Repo.all(
      from team in EspiDni.Team,
      where: not is_nil(team.google_token),
      where: not is_nil(team.google_property_id)
    )
  end

  defp get_article_id(path, team) do
    Repo.one(
      from article in EspiDni.Article,
      join: user in EspiDni.User, on: user.id == article.user_id,
      where: user.team_id == ^team.id,
      where: article.path == ^path,
      select: article.id
    )
  end

  defp create_view_count(view_count_data, team) do
    article_id = get_article_id(view_count_data.path, team)

    if article_id do
      ViewCount.changeset(%ViewCount{}, view_count_data)
      |> Repo.insert!()
    end
  end
end
