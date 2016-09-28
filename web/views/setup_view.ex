defmodule EspiDni.SetupView do
  use EspiDni.Web, :view

  alias EspiDni.Team
  alias EspiDni.GoogleAnalyticsClient

  def web_properties(%Team{} = team) do
    GoogleAnalyticsClient.get_properties(team)
    |> Enum.map(&{&1.name, &1.defaultProfileId})
  end

  def team_changeset(%Team{} = team) do
    EspiDni.Team.changeset(team, %{})
  end
end
