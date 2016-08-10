defmodule EspiDni.User do
  use EspiDni.Web, :model

  schema "users" do
    field :slack_id, :string
    field :username, :string
    field :email,    :string
    field :timezone, :string
    field :name,     :string
    belongs_to :team, EspiDni.Team

    timestamps
  end

end
