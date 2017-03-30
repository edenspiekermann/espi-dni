defmodule EspiDni.SetupController do
  use EspiDni.Web, :controller
  require Logger
  alias EspiDni.Team

  def index(conn, _params) do
    render(conn, "index.html", current_team: conn.assigns.current_team)
  end

  def update(conn, %{"team" => team_params}) do
    team = conn.assigns.current_team
    user = conn.assigns.current_user
    changeset = Team.changeset(team, team_params)

    case Repo.update(changeset) do
      {:ok, team} ->
        finish_integration(team, user)

        conn
        |> put_flash(:info, "Team updated successfully.")
        |> put_session(:current_team, team)
        |> redirect(to: setup_path(conn, :confirm))
      {:error, _changeset} ->
        conn
        |> redirect(to: setup_path(conn, :index))
    end
  end

  def confirm(conn, _params) do
    render(conn, "confirm.html", current_team: conn.assigns.current_team)
  end

  defp finish_integration(team, user) do
    if setup_complete?(team) do
      queue_analytics(team)
      send_completion_message(user)
    end
  end

  defp setup_complete?(team) do
    Team.current_state(team) == :complete
  end

  defp queue_analytics(team) do
    if setup_complete?(team) do
      EspiDni.AnalyticsWorker.queue_job(team)
    end
  end

  defp send_completion_message(user) do
    message = gettext "Setup Complete"

    case EspiDni.SlackWeb.send_message(user, message) do
      %{"ok" => true } ->
        {:ok, user}
      %{"ok" => false, "error" => error} ->
        Logger.error("Could not send completion message to user: #{user.id}. Error: #{inspect error}")
    end
  end
end
