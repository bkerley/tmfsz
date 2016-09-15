defmodule Tmfsz.Router do
  use Tmfsz.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Dmfsz.BasicAuth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Tmfsz do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/search", SearchController, :search
  end

  scope "/admin", Tmfsz do
    pipe_through :admin

    resources "/tweets", TweetController
    resources "/caption", CaptionController, singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", Tmfsz do
  #   pipe_through :api
  # end
end
