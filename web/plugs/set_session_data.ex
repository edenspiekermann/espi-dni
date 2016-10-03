defmodule EspiDni.Plugs.SetSessionData do

  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    conn
    |> set_user(repo)
    |> set_team(repo)
  end

  defp set_user(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(EspiDni.User, user_id)
    assign(conn, :current_user, user)
  end

  defp set_team(conn, repo) do
    team_id = get_session(conn, :team_id)
    team = team_id && repo.get(EspiDni.Team, team_id)
    assign(conn, :current_team, team)
  end
end
