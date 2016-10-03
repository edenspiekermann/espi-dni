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
    cond do
      user = conn.assigns[:current_user] ->
        conn
      user = user_id && repo.get(EspiDni.User, user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  defp set_team(conn, repo) do
    team_id = get_session(conn, :team_id)
    cond do
      team = conn.assigns[:current_team] ->
        conn
      team = team_id && repo.get(EspiDni.Team, team_id) ->
        assign(conn, :current_team, team)
      true ->
        assign(conn, :current_team, nil)
    end
  end
end
