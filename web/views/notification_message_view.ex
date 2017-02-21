defmodule EspiDni.NotificationMessageView do
  use EspiDni.Web, :view

  def notification_types do
    [
      {"View Count Spike Message", "view_count_spike"},
      {"Source Spike Message", "source_spike"}
    ]
  end

  def view_count_messages(messages) do
    messages |> Enum.filter(&(&1.type == "view_count_spike"))
  end

  def source_messages(messages) do
    messages |> Enum.filter(&(&1.type == "source_spike"))
  end

end
