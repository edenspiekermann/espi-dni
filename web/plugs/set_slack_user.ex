defmodule EspiDni.Plugs.SetSlackUser do

  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    case repo.get_by(EspiDni.User, slack_id: user_id(conn)) do
      nil ->
        conn |> send_resp(404, "Unknown User") |> halt
      user ->
        assign(conn, :current_user, user)
    end
  end

  defp user_id(conn) do
    conn.params["user_id"] || get_in(conn.assigns, [:payload, "user", "id"]) || ""
  end

end
