defmodule Tmfsz.Tweet do
  use Tmfsz.Web, :model
  import Ecto.Query, only: [from: 2]

  alias Tmfsz.Repo
  alias Tmfsz.Tweet

  schema "tweets" do
    field :id_str, :string
    field :id_number, :decimal
    field :text, :string
    field :body, :map
    field :created_at, Ecto.DateTime
    field :caption, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id_str, :id_number, :text, :body, :created_at, :caption])
    |> validate_required([:id_str, :id_number, :text, :body, :created_at])
  end

  def index do
    from(t in Tweet,
         order_by: [desc: t.created_at])
    |> Repo.all
  end

  def uncaptioned do
    from(t in Tweet,
         where: is_nil(t.caption) or (t.caption == ""),
         order_by: [asc: fragment("random()")],
         limit: 1)
    |> Repo.one
  end

  def oldest do
    from(t in Tweet,
         order_by: [asc: t.created_at],
         limit: 1)
    |> Repo.one
  end

  def newest do
    from(t in Tweet,
         order_by: [desc: t.created_at],
         limit: 1)
    |> Repo.one
  end

  def consume(tweets) when is_list(tweets) do
    Repo.transaction(fn ->
      Enum.each(tweets, &consume(&1))
    end)
  end

  def consume(api_tweet =
        %ExTwitter.Model.Tweet{
          id: id_num,
          id_str: id_str,
          text: text,
          created_at: created_at
        }) do

    case Repo.get_by(Tweet, id_number: id_num) do
      nil -> %Tweet{id_number: id_num}
      found_tweet -> found_tweet
    end
    |> Tweet.changeset(%{id_str: id_str,
                         text: text,
                         created_at: parse_datetime_str(created_at),
                         body: Map.from_struct(api_tweet)})
    |> Repo.insert_or_update!
  end

  def parse_datetime_str(datetime_str) do
    {:ok, parsed} = datetime_str
    |> Timex.parse("{WDshort} {Mshort} {0D} {0h24}:{0m}:{0s} {Z} {YYYY}")

    parsed
  end

  def image_urls(_tweet = %Tweet{body:
                                %{"extended_entities" =>
                                   %{"media" => images}}})
  when length(images) > 0 do
    images
    |> Enum.map(&image_url(&1))
  end

  def image_urls(_tweet = %Tweet{body:
                                 %{"extended_entities" =>
                                    %{"media" => image}}})
  when is_map(image) do
    image_url(image)
  end

  def image_urls(_other), do: []

  def image_url(image) do
    "#{image["media_url_https"]}:large"
  end
end
