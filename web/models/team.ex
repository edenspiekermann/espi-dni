defmodule EspiDni.Team do
  use EspiDni.Web, :model

  schema "teams" do
    field :slack_token,             :string
    field :google_token,            :string
    field :google_refresh_token,    :string
    field :google_property_id,      :integer
    field :name,                    :string
    field :url,                     :string
    field :slack_id,                :string
    field :google_token_expires_at, Ecto.DateTime
    field :min_view_count_increase, :integer
    field :view_count_threshold,    :integer
    has_many :users,                EspiDni.User

    timestamps
  end

  @required_fields ~w(slack_token name slack_id)
  @optional_fields ~w(
    url google_token google_refresh_token google_property_id
    google_token_expires_at min_view_count_increase view_count_threshold
  )

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def article_paths(team) do
    EspiDni.Repo.all(
      from article in EspiDni.Article,
      join: user in EspiDni.User, on: user.id == article.user_id,
      where: user.team_id == ^team.id,
      select: article.path
    )
  end

  def current_state(team) do
    case team  do
      %{slack_token: nil, google_token: nil, google_refresh_token: nil, google_property_id: nil} ->
        :new
      %{slack_token: _, google_token: nil, google_refresh_token: nil, google_property_id: nil} ->
        :awaiting_google_token
      %{slack_token: _, google_token: _, google_refresh_token: nil, google_property_id: nil} ->
        :awaiting_refresh_token
      %{slack_token: _, google_token: _, google_refresh_token: _, google_property_id: nil} ->
        :awaiting_google_property
      %{slack_token: _, google_token: _, google_refresh_token: _, google_property_id: _} ->
        :complete
    end
  end
end
