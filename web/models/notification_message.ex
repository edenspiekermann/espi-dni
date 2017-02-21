defmodule EspiDni.NotificationMessage do

  use EspiDni.Web, :model
  alias EspiDni.{
    Repo,
    NotificationMessage
  }

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

  def random_message(team_id, type) do
    Repo.one(
      from notification_message in NotificationMessage,
      where: notification_message.team_id == ^team_id,
      where: notification_message.type == ^type,
      order_by: fragment("RANDOM()"),
      limit: 1
    )
  end

end
