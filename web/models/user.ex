defmodule EspiDni.User do
  use EspiDni.Web, :model

  schema "users" do
    field :slack_id, :string
    field :username, :string
    field :email, :string
    field :timezone, :string
    field :name, :string
    belongs_to :team, EspiDni.Team

    timestamps
  end

  @required_fields ~w(slack_id username team_id)
  @optional_fields ~w(email timezone name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
