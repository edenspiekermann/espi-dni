defmodule EspiDni.Repo.Migrations.AddArticleUrlUniqueConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:articles, [:user_id, :url], name: "unique_user_article")
  end
end
