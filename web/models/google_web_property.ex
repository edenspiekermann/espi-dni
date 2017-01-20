defmodule EspiDni.GoogleWebProperty do
  @derive [Poison.Encoder]
  defstruct [:id, :name, :websiteUrl]
end
