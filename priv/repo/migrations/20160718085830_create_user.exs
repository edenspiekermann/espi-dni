defmodule EspiDni.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :slack_id, :string, null: false
      add :username, :string, null: false
      add :email,    :string, null: false

      timestamps
    end

    create unique_index(:users, [:slack_id])
  end
end
