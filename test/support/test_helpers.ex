defmodule EspiDni.TestHelpers do
  alias EspiDni.Repo

  def insert_team(attrs \\ %{}) do
    changes = Dict.merge(%{
      token: "supersecret",
      name: "Some User",
      url: "http://espi-dni.slack.com/foobar",
      slack_id: "token#{Base.encode16(:crypto.rand_bytes(8))}",
    }, attrs)

    %EspiDni.Team{}
    |> EspiDni.Team.changeset(changes)
    |> Repo.insert!()
  end

  def insert_user(team, attrs \\ %{}) do
    user_attrs = Dict.merge(%{
      slack_id: "token#{Base.encode16(:crypto.rand_bytes(8))}",
      username: "username",
      email: "email@email.com",
      name: "Some User",
    }, attrs)

    team
    |> Ecto.build_assoc(:users, user_attrs)
    |> Repo.insert!()
  end

  def slack_token do
    Application.get_env(:espi_dni, EspiDni.Plugs.RequireSlackToken)[:slack_token]
  end

end

