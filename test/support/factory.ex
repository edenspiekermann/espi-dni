defmodule EspiDni.Factory do
  use ExMachina.Ecto, repo: EspiDni.Repo

  def team_factory do
    %EspiDni.Team {
      slack_token: "supersecret",
      name: "some team",
      slack_id: sequence(:slack_id, &"team_token-#{&1}")
    }
  end

  def user_factory do
    %EspiDni.User{
      name: "Some User",
      username: sequence(:username, &"user-#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      slack_id: sequence(:slack_id, &"user_token-#{&1}")
    }
  end

  def article_factory do
    %EspiDni.Article{
      url: sequence(:url, &"http://www.example.com/foobar-#{&1}"),
      path: sequence(:path, &"foobar-#{&1}")
    }
  end

  def view_count_factory do
    %EspiDni.ViewCount{}
  end

  def insert_previous_view_count(attrs \\ %{}) do
    half_hour_ago = Ecto.DateTime.cast!(Timex.shift(Timex.now, minutes: -30))

    build(:view_count, attrs)
    |> Map.merge(%{inserted_at: half_hour_ago, updated_at: half_hour_ago})
    |> insert
  end
end
