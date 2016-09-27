defmodule EspiDni.Repo.Migrations.AddGoogleTokenExpiresAtToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :google_token_expires_at, :datetime
    end
  end
end
