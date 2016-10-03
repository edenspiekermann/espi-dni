defmodule EspiDni.PageController do
  use EspiDni.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", current_team: conn.assigns.current_team
  end
end
