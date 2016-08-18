defmodule EspiDni.Plugs.ParseSlackPayloadTest do

  use EspiDni.ConnCase, async: true

  test "does nothing if the payload is missing" do
    conn =
      conn(:get, "/", %{})
      |> EspiDni.Plugs.ParseSlackPayload.call(%{})

    refute conn.halted
  end

  test "parses and sets the payload" do
    conn =
      conn(:get, "/", %{payload: "{\"foo\": \"bar\" }"})
      |> EspiDni.Plugs.ParseSlackPayload.call(%{})

    conn.assigns.payload == %{"foo" => "bar"}
  end
end
