defmodule EspiDni.SlackArticleView do
  use EspiDni.Web, :view
  import EspiDni.Gettext

  def render("confirm.json", %{url: url}) do
    %{
      response_type: "ephemeral",
      text: gettext("Article Confirm Prompt", %{url: url}),
      attachments: [
        %{
          fallback: "Please enable interactive messages to confirm the article",
          callback_id: "confirm_article",
          color: "#31b0e2",
          attachment_type: "default",
          actions: [
            %{
              name: "yes",
              text: gettext("Article Confirm"),
              type: "button",
              value: "#{url}"
            },
            %{
              name: "no",
              text: gettext("Article Refute"),
              type: "button",
              value: "#{url}"
            }
          ]
        }
      ]
    }
  end
end
