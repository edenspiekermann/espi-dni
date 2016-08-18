defmodule EspiDni.Plugs.SetSlackUser do

  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    slack_id = conn.params["user_id"]
    user = slack_id && repo.get_by(EspiDni.User, slack_id: slack_id)
    assign(conn, :current_user, user)
  end
end
