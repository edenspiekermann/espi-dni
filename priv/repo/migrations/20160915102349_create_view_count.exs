defmodule EspiDni.Repo.Migrations.CreateViewCount do
  use Ecto.Migration

  def change do
    create table(:view_counts) do
      add :count, :integer, default: 0
      add :article_id, references(:articles, on_delete: :delete_all)

      timestamps
    end
    create index(:view_counts, [:article_id])

  end
end
