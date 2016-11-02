defmodule EspiDni.Repo.Migrations.AddSourecePreferencesToTeam do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :min_source_count_increase, :integer
      add :source_count_threshold, :integer
    end
  end
end
