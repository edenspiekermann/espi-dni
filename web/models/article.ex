defmodule EspiDni.Article do
  use EspiDni.Web, :model
  alias EspiDni.ViewCount
  alias EspiDni.Article
  alias EspiDni.User
  alias EspiDni.Repo

  schema "articles" do
    field :url, :string
    field :path, :string
    belongs_to :user, EspiDni.User
    has_many :view_counts, EspiDni.ViewCount

    timestamps
  end

  @required_fields ~w(url user_id)
  @optional_fields ~w(path)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> set_path()
    |> validate_url(:url)
    |> unique_constraint(:url, name: :unique_user_article)
  end

  def recently_active(team) do
    Repo.all(
      from article in Article,
      join: view_count in ViewCount, on: view_count.article_id == article.id,
      join: user in User, on: user.id == article.user_id,
      where: view_count.inserted_at < ago(5, "minute"),
      where: user.team_id == ^team.id,
      group_by: article.id,
      preload: :user
    )
  end

  defp validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, _msg} ->
          [{field, options[:message] || "is not a valid URL!"}]
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
