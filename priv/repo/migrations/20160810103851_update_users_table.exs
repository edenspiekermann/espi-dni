defmodule EspiDni.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :team_id, references(:teams)
      add :timezone, :string
      add :name, :string
    end
  end
end
