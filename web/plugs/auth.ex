defmodule EspiDni.Plugs.Auth do

  @moduledoc """
  Ensure that the current team and current user set on the conn
  Passes through it they are set, halts otherwise
  """

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
