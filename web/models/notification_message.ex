defmodule EspiDni.NotificationMessage do
  use EspiDni.Web, :model

  schema "notification_messages" do
    field :text, :string
    field :type, :string
    belongs_to :team, EspiDni.Team

    timestamps()
  end

  @required_fields ~w(text type team_id)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
