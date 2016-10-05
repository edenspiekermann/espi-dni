defmodule EspiDni.Plugs.ParseSlackPayloadTest do

  use EspiDni.ConnCase, async: true

  test "does nothing if the payload is missing" do
    conn =
      build_conn(:get, "/", %{})
      |> EspiDni.Plugs.ParseSlackPayload.call(%{})

    assert get_in(conn.assigns, [:payload, "token"]) == nil
    refute conn.halted
  end

  test "parses and sets the payload" do
    conn =
      build_conn(:get, "/", %{payload: Poison.encode!(%{"foo" => "bar"})})
      |> EspiDni.Plugs.ParseSlackPayload.call(%{})

    assert conn.assigns.payload == %{"foo" => "bar"}
  end
end
