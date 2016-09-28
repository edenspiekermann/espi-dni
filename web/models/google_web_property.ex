defmodule EspiDni.GoogleWebProperty do
  @derive [Poison.Encoder]
  defstruct [:defaultProfileId, :name]
end
