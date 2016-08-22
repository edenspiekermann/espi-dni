defmodule EspiDni.Plugs.ParseSlackPayload do

  import Plug.Conn

  def init(default), do: default

  def call(conn = %Plug.Conn{params: %{"payload" => payload}}, _opts) do
    case Poison.decode(payload) do
      {:ok, parsed_payload} ->
        assign(conn, :payload, parsed_payload)
      _ ->
        conn
    end
  end

  def call(conn, _opts), do: conn
end
