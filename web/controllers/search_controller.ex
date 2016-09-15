defmodule Tmfsz.SearchController do
  use Tmfsz.Web, :controller

  alias Tmfsz.SearchTweet

  def search(conn, %{"search" => %{"q" => query}}) do
    results = SearchTweet.search(query)

    render(conn, "search.html", results: results)
  end
end
