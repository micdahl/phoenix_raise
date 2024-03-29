defmodule PhoenixRiseWeb.Router do
  use PhoenixRiseWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PhoenixRiseWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixRiseWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/countries", CountryLive.Index, :index
    live "/countries/new", CountryLive.Index, :new
    live "/countries/:id/edit", CountryLive.Index, :edit
    live "/countries/:id", CountryLive.Show, :show
    live "/countries/:id/show/edit", CountryLive.Show, :edit

    live "/contacts", ContactLive.Index, :index
    live "/contacts/new", ContactLive.Index, :new
    live "/contacts/:id/edit", ContactLive.Index, :edit

    live "/contacts/:id", ContactLive.Show, :show
    live "/contacts/:id/show/edit", ContactLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixRiseWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phoenix_rise, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixRiseWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
