defmodule Tmfsz.PageController do
  use Tmfsz.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
