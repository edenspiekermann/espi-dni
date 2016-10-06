defmodule EspiDni.PreferenceController do
  use EspiDni.Web, :controller
  alias EspiDni.Team

  plug :authenticate

  def update(conn, %{"team" => team_params}) do
    team = conn.assigns.current_team
    changeset = Team.changeset(team, team_params)

    case Repo.update(changeset) do
      {:ok, team} ->
        conn
        |> put_flash(:info, "Preferences updated successfully.")
        |> assign(:current_team, team)
        |> redirect(to: article_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> redirect(to: article_path(conn, :index))
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_team && conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

end
