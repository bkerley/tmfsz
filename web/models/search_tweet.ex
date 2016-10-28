defmodule Tmfsz.SearchTweet do
  use Tmfsz.Web, :model
  import Ecto.Query, only: [from: 2]

  alias Tmfsz.Repo

  alias Tmfsz.SearchTweet

  schema "search_tweets" do
    field :id_str, :string
    field :id_number, :decimal
    field :text, :string
    field :body, :map
    field :created_at, Ecto.DateTime
    field :caption, :string

    timestamps()
  end

  def search(text) do
    cond do
      results = search_tsquery(text) -> results
      results = search_plainto_tsquery(text) -> results
    end
  end

  defp search_tsquery(text) do
    try do
      from(st in SearchTweet,
           where: fragment("tsv @@ to_tsquery(?)", ^text),
           select: {st, fragment("ts_rank(tsv, to_tsquery(?)) as rank", ^text)},
           order_by: fragment("rank desc"))
      |> Repo.all
    rescue
      _e in Postgrex.Error -> false
    end
  end

  defp search_plainto_tsquery(text) do
    try do
      from(st in SearchTweet,
           where: fragment("tsv @@ plainto_tsquery(?)", ^text),
           select: {st,
                    fragment("ts_rank(tsv, plainto_tsquery(?)) as rank",
                             ^text)},
           order_by: fragment("rank desc"))
      |> Repo.all
    rescue
      _e in Postgrex.Error -> false
    end
  end
end
