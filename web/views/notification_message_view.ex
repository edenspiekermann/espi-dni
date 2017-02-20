defmodule EspiDni.NotificationMessageView do
  use EspiDni.Web, :view

  def notification_types do
    [{"one", "foo"}, {"two", "Test"}]
  end

end
