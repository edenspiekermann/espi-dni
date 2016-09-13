defmodule EspiDni.Repo.Migrations.AddGoogleTokensToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :google_token, :string
      add :google_refresh_token, :string
    end
  end
end
