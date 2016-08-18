defmodule EspiDni.Plugs.RequireSlackToken do

  import Plug.Conn

  @token Application.get_env(:espi_dni, __MODULE__)[:slack_token]

  def init(default), do: default

  def call(conn, _opts) do
    case request_token(conn) do
      @token ->
        conn
      _other ->
        conn |> send_resp(401, "Unauthorized") |> halt
    end
  end

  defp request_token(conn) do
    conn.params["token"] || get_in(conn.assigns, [:payload, "token"])
  end
end
