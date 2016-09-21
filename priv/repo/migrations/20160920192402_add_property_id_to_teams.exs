defmodule EspiDni.Repo.Migrations.AddPropertyIdToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :google_property_id, :integer
    end
  end
end
