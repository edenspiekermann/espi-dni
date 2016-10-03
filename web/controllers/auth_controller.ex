defmodule EspiDni.AuthController do
  use EspiDni.Web, :controller
  alias EspiDni.SlackAuthHandler
  alias EspiDni.GoogleAuthHandler
  plug Ueberauth

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => "slack"} = _params) do
    case SlackAuthHandler.init_from_auth(auth) do
      {:ok, team, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> assign_team_and_user(team, user)
        |> start_bot
        |> redirect(to: setup_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => "google"} = _params) do
    team = conn.assigns.current_team

    case GoogleAuthHandler.update_from_auth(team, auth) do
      {:ok, team} ->
        conn
        |> put_flash(:info, "Team updated successfully.")
        |> assign(:current_team, team)
        |> redirect(to: setup_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:info, "A problem occurred")
        |> redirect(to: "/")
    end
  end

  defp start_bot(conn) do

    team = conn.assigns.current_team
    EspiDni.BotSupervisor.start_bot(team.slack_token)
    conn
  end

  defp assign_team_and_user(conn, team, user) do
    conn
    |> put_session(:team_id, team.id)
    |> put_session(:user_id, user.id)
    |> assign(:current_team, team)
    |> assign(:current_user, user)
  end

end
