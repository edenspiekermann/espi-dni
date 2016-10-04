defmodule EspiDni.SetupController do
  use EspiDni.Web, :controller
  alias EspiDni.Team

  def index(conn, _params) do
    render(conn, "index.html", current_team: conn.assigns.current_team)
  end

  def update(conn, %{"team" => team_params}) do
    team = conn.assigns.current_team
    changeset = Team.changeset(team, team_params)

    case Repo.update(changeset) do
      {:ok, team} ->
        conn
        |> put_flash(:info, "Team updated successfully.")
        |> put_session(:current_team, team)
        |> redirect(to: setup_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> redirect(to: setup_path(conn, :index))
    end
  end

  defp queue_analytics(team) do
    if ready_for_analytics? do
      EspiDni.AnalyticsSupervisor.start_anlaytics_worker(team)
    end
  end

  defp ready_for_analytics?(team) do
    !!(team.google_token && team.google_property_id && team.google_refresh_token)
  end

end
