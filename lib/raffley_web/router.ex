defmodule RaffleyWeb.Router do
  use RaffleyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RaffleyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :spy
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RaffleyWeb do
    pipe_through :browser

    # get "/", PageController, :home
    get "/rules", RuleController, :index
    get "/rules/:id", RuleController, :show
    live "/", RaffleLive.Index
    live "/estimator", EstimatorLive
    live "/raffles", RaffleLive.Index
    live "/raffles/:id", RaffleLive.Show

    live "/admin/raffles", AdminRaffleLive.Index
    live "/admin/raffles/new", AdminRaffleLive.Form, :new
    live "/admin/raffles/:id/edit", AdminRaffleLive.Form, :edit

    live "/charities", CharityLive.Index, :index
    live "/charities/new", CharityLive.Form, :new
    live "/charities/:id", CharityLive.Show, :show
    live "/charities/:id/edit", CharityLive.Form, :edit
  end

  def spy(conn, _opts) do
    greeting = ~w(Hi Howdy Hello) |> Enum.random()

    conn = assign(conn, :greeting, greeting)

    IO.inspect(conn)
    conn
  end

  # Other scopes may use custom stacks.
  scope "/api", RaffleyWeb.Api do
    pipe_through :api

    get "/raffles", RaffleController, :index
    get "/raffles/:id", RaffleController, :show
    post "/raffles", RaffleController, :create
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:raffley, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RaffleyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
