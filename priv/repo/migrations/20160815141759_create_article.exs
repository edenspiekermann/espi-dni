defmodule EspiDni.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :url, :string, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end

    create index(:articles, [:user_id])
  end
end
