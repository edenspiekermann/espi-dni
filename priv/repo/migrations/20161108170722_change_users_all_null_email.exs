defmodule EspiDni.Repo.Migrations.ChangeUsersAllNullEmail do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :email, :string, null: true
    end
  end
end
