defmodule EspiDni.ViewCountHandler do

  require Logger
  alias EspiDni.Repo
  alias EspiDni.ViewCount
  import Ecto.Query

  def process_view_count(view_count_data, team) do
    article_id = get_article_id(view_count_data.path, team)

    case create_view_count(article_id, view_count_data) do
      {:ok, view_count} ->
        view_count
      {:error, changeset} ->
        Logger.error "Cannot create view_count: #{inspect changeset}"
      _ ->
        nil
    end
  end

  # if we can't find the article for the path, don't create a view_count
  defp create_view_count(nil, _), do: :nil

  defp create_view_count(article_id, view_count_data) do
    ViewCount.changeset(%ViewCount{}, Map.merge(%{article_id: article_id}, view_count_data))
    |> Repo.insert()
  end

  defp get_article_id(path, team) do
    Repo.one(
      from article in EspiDni.Article,
      select: article.id,
      join: user in EspiDni.User, on: user.id == article.user_id,
      where: user.team_id == ^team.id,
      where: article.path == ^path
    )
  end

end
