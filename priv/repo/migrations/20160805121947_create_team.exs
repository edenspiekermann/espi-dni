defmodule EspiDni.Repo.Migrations.CreateTeam do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :token,    :string, null: false
      add :name,     :string, null: false
      add :slack_id, :string, null: false
      add :url,      :string

      timestamps
    end
  end
end
