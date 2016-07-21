defmodule EspiDni.User do
  use EspiDni.Web, :model

  schema "users" do
    field :slack_id, :string
    field :username, :string
    field :email, :string

    timestamps
  end

end
