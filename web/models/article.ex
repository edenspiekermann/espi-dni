defmodule EspiDni.Article do
  use EspiDni.Web, :model

  schema "articles" do
    field :url, :string
    field :path, :string
    belongs_to :user, EspiDni.User

    timestamps
  end

  @required_fields ~w(url user_id)
  @optional_fields ~w(path)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> set_path()
    |> validate_url(:url)
  end

  defp validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} ->
          [{field, options[:message] || "#{url} is not a valid URL!"}]
      end
    end
  end

  defp set_path(changeset) do
    if url = get_change(changeset, :url) do
      put_change(changeset, :path, extract_path(url))
    else
      changeset
    end
  end

  defp extract_path(url) do
    case URI.parse(url) do
      %URI{path: nil} -> "/"
      %URI{path: path} -> path
    end
  end
end
