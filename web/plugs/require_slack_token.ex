defmodule EspiDni.Plugs.RequireSlackToken do

  @moduledoc """
  Checks if the Slack token is present (a secret token that should be present
  on all requests coming from slack verifying it is a real requeat)
  Passes through if it's present, halts otherwise
  """

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
