ExUnit.start
Ecto.Adapters.SQL.Sandbox.mode(EspiDni.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.configure(timeout: :infinity)
