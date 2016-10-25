defmodule EspiDni.Repo.Migrations.AddSourceToViewCounts do
  use Ecto.Migration

  def change do
    alter table(:view_counts) do
      add :source, :string
    end
  end
end
