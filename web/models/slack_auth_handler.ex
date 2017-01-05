defmodule EspiDni.SlackAuthHandler do

  @moduledoc """
  Create or retreive the team and user from an auth request
  """
  alias Ueberauth.Auth
  alias EspiDni.TeamFromAuth
  alias EspiDni.UserFromAuth
  import EspiDni.Gettext

  def init_from_auth(%Auth{} = auth) do
    with {:ok, team} <- TeamFromAuth.find_or_create(auth),
         {:ok, user} <- UserFromAuth.find_or_create(auth, team),
         {:ok, user} <- send_welcome_message(user, team) do
      {:ok, team, user}
    end
    |> case do
        {:ok, team, user} -> {:ok, team, user}
        {:error, changeset} -> {:error, changeset}
      end
  end

  defp send_welcome_message(user, team) do
    message = team_message(team)
    case EspiDni.SlackWeb.send_message(user, message) do
      %{"ok" => true } -> {:ok, user}
      %{"ok" => false } -> {:error, user}
    end
  end

  defp team_message(team) do
    case EspiDni.Team.current_state(team) do
      :new -> gettext "Initial Greeting"
      :awaiting_google_property -> gettext "Awaiting Google Property"
      :complete -> gettext "Welcome Back"
      _ -> gettext "Awaiting Google Property"
    end
  end
end
