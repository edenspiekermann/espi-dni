defmodule EspiDni.Repo.Migrations.RenameTeamTokenColumn do
  use Ecto.Migration

  def change do
    rename table(:teams), :token, to: :slack_token
  end
end
