defmodule EspiDni.SlackArticleView do
  use EspiDni.Web, :view

  def render("confirm.json", %{url: url}) do
    %{
      response_type: "ephemeral",
      text: "Okay, you'd like to register the article at #{url}?",
      attachments: [
        %{
          fallback: "Please enable interactive messages to confirm the article",
          callback_id: "confirm_article",
          color: "#8654e5",
          attachment_type: "default",
          actions: [
            %{
              name: "yes",
              text: "Yes, that's it.",
              type: "button",
              value: "#{url}"
            },
            %{
              name: "no",
              text: "Nope",
              type: "button",
              value: "no"
            }
          ]
        }
      ]
    }
  end
end
