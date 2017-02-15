defmodule EspiDni.Plugs.AuthTest do

  import EspiDni.Factory
  use EspiDni.ConnCase, async: true

  describe "without a user and team set" do
    setup do
      conn =
        build_conn
        |> bypass_through(EspiDni.Router, :browser)
        |> get("/")

      {:ok, conn: conn}
    end

    test "halts if the user and team are not set", %{conn: conn} do
      conn = conn |> EspiDni.Plugs.Auth.call(%{})

      assert conn.halted
    end
  end


  describe "when user and team are set" do
    setup do
      team = build(:team)
      user = build(:user)
      conn =
        build_conn
        |> bypass_through(EspiDni.Router, :browser)
        |> assign(:current_team, team)
        |> assign(:current_user, user)
        |> get("/")
        |> EspiDni.Plugs.Auth.call(%{})

      {:ok, user: user, team: team, conn: conn}
    end

    test "passes through if the user and team are set", %{conn: conn} do
      conn = conn |> EspiDni.Plugs.Auth.call(%{})

      refute conn.halted
    end
  end
end
