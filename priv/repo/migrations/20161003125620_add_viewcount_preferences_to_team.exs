defmodule EspiDni.Repo.Migrations.AddViewcountPreferencesToTeam do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :min_view_count_increase, :integer
      add :view_count_threshold, :integer
    end
  end
end
