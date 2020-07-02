defmodule DhSmsWeb.Router do
  use DhSmsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DhSmsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    post "/contacts/bulk", DhSmsWeb.ApiContactController, :bulk_create
  end

  scope "/", DhSmsWeb do
    pipe_through :browser

    resources "/campaigns", CampaignController do
      # resources "/conversations", ConversationController do
      #   resources "/contacts", ContactController
      #   resources "/messages", MessageController
      # end
    end

    resources "/contacts", ContactController



    live "/", PageLive, :index

  end

  # Other scopes may use custom stacks.
  # scope "/api", DhSmsWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DhSmsWeb.Telemetry
    end
  end
end
