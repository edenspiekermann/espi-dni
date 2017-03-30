defmodule EspiDni.GoogleWebProperty do

  @moduledoc """
  A module representing a Google Analytics web property account
  """

  @derive [Poison.Encoder]
  defstruct [:id, :name, :websiteUrl]
end
