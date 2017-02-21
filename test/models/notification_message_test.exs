defmodule EspiDni.NotificationMessageTest do
  use EspiDni.ModelCase

  alias EspiDni.NotificationMessage

  @valid_attrs %{text: "some content", type: "some content", team_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = NotificationMessage.changeset(%NotificationMessage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = NotificationMessage.changeset(%NotificationMessage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
