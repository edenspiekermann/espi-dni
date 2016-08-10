defmodule EspiDni.AuthHandler do

  @moduledoc """
  Create or retreive the team and user from an auth request
  """
  alias Ueberauth.Auth
  alias EspiDni.TeamFromAuth

  def init_from_auth(%Auth{} = auth) do
    with {:ok, team} <- TeamFromAuth.find_or_create(auth) do
         {:ok, team}
    end
  end

end
