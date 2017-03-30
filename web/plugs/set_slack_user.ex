defmodule EspiDni.Plugs.SetSlackUser do

  @moduledoc """
  Finds the team from the slack params
  If the team does not exist, returns a 404
  If the team exits, a user is found or creates from the slack params and
  added to the conn
  """

  import Plug.Conn
  alias EspiDni.User
  alias EspiDni.Team

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    case team(conn, repo) do
      nil ->
        conn |> send_resp(404, "Unknown User") |> halt
      team ->
        user = get_or_create_user(conn, team, repo)
        assign(conn, :current_user, user)
    end
  end

  defp user_id(conn) do
    conn.params["user_id"] || get_in(conn.assigns, [:payload, "user", "id"]) || ""
  end

  defp team_id(conn) do
    conn.params["team_id"] || get_in(conn.assigns, [:payload, "team", "id"]) || ""
  end

  defp team(conn, repo) do
    repo.get_by(Team, slack_id: team_id(conn))
  end

  defp get_or_create_user(conn, team, repo) do
    case repo.get_by(User, slack_id: user_id(conn), team_id: team.id) do
      nil -> create_user(conn, team, repo)
      user -> user
    end
  end

  defp create_user(conn, team, repo) do
    repo.insert!(build_user(conn.params, team))
  end

  defp build_user(%{"user_name" => username, "user_id" => slack_id}, team) do
    %User{username: username, slack_id: slack_id, team_id: team.id}
  end

end
