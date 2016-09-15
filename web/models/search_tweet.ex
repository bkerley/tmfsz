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
    from(st in SearchTweet,
         where: fragment("tsv @@ to_tsquery(?)", ^text),
         select: {st, fragment("ts_rank(tsv, to_tsquery(?)) as rank", ^text)},
         order_by: fragment("rank desc"))
    |> Repo.all
  end
end
