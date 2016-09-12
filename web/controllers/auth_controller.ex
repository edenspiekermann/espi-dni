defmodule EspiDni.AuthController do
  use EspiDni.Web, :controller
  alias EspiDni.AuthHandler
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
    case AuthHandler.init_from_auth(auth) do
      {:ok, team, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_team, team)
        |> put_session(:current_user, user)
        |> start_bot
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => "google"} = _params) do
    conn
    |> put_flash(:info, "Successfully authenticated with google.")
  end

  defp start_bot(conn) do
    team = get_session(conn, :current_team)
    EspiDni.BotSupervisor.start_bot(team.token)
    conn
  end
end
