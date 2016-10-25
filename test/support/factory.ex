defmodule EspiDni.Factory do
  use ExMachina.Ecto, repo: EspiDni.Repo

 def view_count_factory do
    %EspiDni.ViewCount{
      count: 5,
    }
  end
end
