defmodule EspiDni.SetupView do
  use EspiDni.Web, :view

  alias EspiDni.Team
  alias EspiDni.GoogleAnalyticsClient
  alias EspiDni.GoogleWebProperty

  def web_properties(%Team{} = team) do
    team
    |> GoogleAnalyticsClient.get_properties
    |> Enum.map(&select_options(&1))
  end

  def team_changeset(%Team{} = team) do
    EspiDni.Team.changeset(team, %{})
  end

  defp select_options(%GoogleWebProperty{} = property) do
    {"[#{property.websiteUrl}] - #{property.name}", property.id}
  end
end
