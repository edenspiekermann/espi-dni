defmodule EspiDni.ViewCount do

  @moduledoc """
  A module to represent an article viewcount
  A viewcount holds the number of viewcounts for a source for a 30 minute
  period
  """


  use EspiDni.Web, :model

  schema "view_counts" do
    field :count, :integer
    field :source, :string
    belongs_to :article, EspiDni.Article

    timestamps
  end

  @required_fields ~w(count article_id)
  @optional_fields ~w(source)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
