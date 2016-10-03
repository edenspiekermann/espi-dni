defmodule EspiDni.SetupController do
  use EspiDni.Web, :controller
  alias EspiDni.Team

  def index(conn, _params) do
    render conn, "index.html", current_team: get_session(conn, :current_team)
  end

  def update(conn, %{"team" => team_params}) do
    team = get_session(conn, :current_team)
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

end
