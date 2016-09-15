defmodule EspiDni.Repo.Migrations.AddPathToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :path, :string, null: false
    end
  end
end
