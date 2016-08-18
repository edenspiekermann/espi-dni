defmodule EspiDni.Plugs.RequireSlackTokenTest do

  use EspiDni.ConnCase, async: true

  test "returns unauthorised wheh the token is missing" do
    conn =
      conn(:get, "/", %{})
      |> EspiDni.Plugs.RequireSlackToken.call(%{})

    assert conn.halted
    assert conn.status == 401
  end

  test "returns unauthorised wheh the param token is invalid" do
    conn =
      conn(:get, "/", %{token: "invalid"})
      |> EspiDni.Plugs.RequireSlackToken.call(%{})

    assert conn.halted
    assert conn.status == 401
  end

  test "returns unauthorised wheh the payload token is invalid" do
    conn =
      conn(:get, "/", %{})
      |> assign(:payload, %{"token" => "invalid"})
      |> EspiDni.Plugs.RequireSlackToken.call(%{})

    assert conn.halted
    assert conn.status == 401
  end

  test "request passes through when the correct token is present" do
    conn =
      conn(:get, "/", %{token: slack_token})
      |> EspiDni.Plugs.RequireSlackToken.call(%{})

    refute conn.halted
  end

  test "request passes through when the correct token is present in payload params" do
    conn =
      conn(:get, "/", %{})
      |> assign(:payload, %{"token" => slack_token})
      |> EspiDni.Plugs.RequireSlackToken.call(%{})

    refute conn.halted
  end
end
