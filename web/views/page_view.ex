defmodule EspiDni.PageView do
  use EspiDni.Web, :view
  alias EspiDni.Team

  def team_state(%Team{} = team) do
    EspiDni.Team.current_state(team)
  end
  def team_state(nil), do: :new
end
