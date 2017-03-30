defmodule EspiDni.GoogleWebProperty do

  @moduledoc """
  A module representing a google analytics web property account
  """

  @derive [Poison.Encoder]
  defstruct [:id, :name, :websiteUrl]
end
