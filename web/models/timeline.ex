defmodule Tmfsz.Timeline do
  import ExTwitter, only: [user_timeline: 1]

  alias Tmfsz.Tweet

  @screen_name "dasharez0ne"
  @max_count 200

  def initial do
    user_timeline(screen_name: @screen_name,
                  count: @max_count)
    |> Tweet.consume
  end

  def update do
    newest = Tweet.newest

    since = newest.id_number

    update(since)
    |> List.flatten
    |> Tweet.consume
  end

  def update(since) do
    tweets = user_timeline(screen_name: @screen_name,
                           count: @max_count,
                           since_id: since)

    case length(tweets) do
      @max_count -> update(since, tweets)
      _other -> tweets
    end
  end

  def update(since, accum) do
    got_min = Enum.min_by(accum, &Map.get(&1, :id))
    next_max = got_min - 1

    tweets = user_timeline(screen_name: @screen_name,
                           count: @max_count,
                           since_id: since,
                           max_id: next_max)

    tweets_accum = [tweets | accum]

    case length(tweets) do
      @max_count -> update(since, tweets_accum)
      _other -> tweets_accum
    end
  end

  def delve do
    oldest = Tweet.oldest
    next_max = Decimal.add(oldest.id_number, Decimal.new(-1))

    tweets = user_timeline(screen_name: @screen_name,
                  count: @max_count,
                  max_id: next_max)

    tweets
    |> Tweet.consume

    case length(tweets) do
      @max_count -> delve
      _other -> :ok
    end
  end
end
