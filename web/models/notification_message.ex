defmodule EspiDni.NotificationMessage do
  use EspiDni.Web, :model

  schema "notification_messages" do
    field :text, :string
    field :type, :string
    belongs_to :team, EspiDni.Team

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text, :type])
    |> validate_required([:text, :type])
  end
end
