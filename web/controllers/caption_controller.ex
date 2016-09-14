defmodule Tmfsz.CaptionController do
  use Tmfsz.Web, :controller

  alias Tmfsz.Repo
  alias Tmfsz.Tweet

  def show(conn, _params) do
    tweet = Tweet.uncaptioned
    cset = Tweet.changeset(tweet)

    render(conn, "show.html", tweet: tweet, changeset: cset)
  end

  def update(conn, %{"tweet" => tweet_params}) do
    tweet = Repo.get_by!(Tweet, id_number: tweet_params["id_number"])
    cset = Tweet.changeset(tweet, tweet_params)

    case Repo.update(cset) do
      {:ok, _tweet} ->
        conn
        |> put_flash(:info, "thanks!")
        |> redirect(to: caption_path(conn, :show))
      {:error, err_cset} ->
        render(conn, "show.html", tweet: tweet, changeset: err_cset)
    end
  end
end
