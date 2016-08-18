defmodule EspiDni.Team do
  use EspiDni.Web, :model

  schema "teams" do
    field :token,    :string
    field :name,     :string
    field :url,      :string
    field :slack_id, :string
    has_many :users, EspiDni.User

    timestamps
  end

  @required_fields ~w(token name slack_id)
  @optional_fields ~w(url)

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
