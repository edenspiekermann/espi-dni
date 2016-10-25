defmodule EspiDni.Factory do
  use ExMachina.Ecto, repo: EspiDni.Repo

  def view_count_factory do
    %EspiDni.ViewCount{}
  end

end
