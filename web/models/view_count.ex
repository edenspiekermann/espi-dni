defmodule EspiDni.ViewCount do
  use EspiDni.Web, :model

  schema "view_counts" do
    field :count, :integer
    belongs_to :article, EspiDni.Article

    timestamps
  end

  @required_fields ~w(count article_id)
  @optional_fields ~w()

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
