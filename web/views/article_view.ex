defmodule EspiDni.ArticleView do
  use EspiDni.Web, :view
  alias EspiDni.Team

  @minimum_increase 10
  @increase_threshold_percentage 25

  def team_changeset(%Team{} = team) do
    min_view_count_increase   = team.min_view_count_increase || @minimum_increase
    min_source_count_increase = team.min_source_count_increase || @minimum_increase
    view_count_threshold      = team.view_count_threshold || @increase_threshold_percentage
    source_count_threshold    = team.source_count_threshold || @increase_threshold_percentage

    EspiDni.Team.changeset(
      team, %{
        min_view_count_increase: min_view_count_increase,
        min_source_count_increase: min_source_count_increase,
        view_count_threshold: view_count_threshold,
        source_count_threshold: source_count_threshold,
    })
  end
end
