defmodule EspiDni.PageController do
  use EspiDni.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", current_team: get_session(conn, :current_team)
  end
end
