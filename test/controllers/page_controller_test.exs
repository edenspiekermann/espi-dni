defmodule EspiDni.PageControllerTest do
  use EspiDni.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Meet POST Bot"
  end
end
