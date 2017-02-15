defmodule EspiDni.Plugs.Auth do

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(default), do: default

  def call(conn, _repo) do
    if conn.assigns.current_team && conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: EspiDni.Router.Helpers.page_path(conn, :index))
      |> halt
    end
  end

end
