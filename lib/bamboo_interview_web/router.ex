defmodule BambooInterviewWeb.Router do
  use BambooInterviewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BambooInterviewWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BambooInterviewWeb.Plug.AuthAccessPipeline
  end

  scope "/", BambooInterviewWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", BambooInterviewWeb do
    pipe_through :api
    post "/auth/login", UserController, :login
    post "/users", UserController, :create

    scope "/" do
      pipe_through :auth
      get "/users/:id", UserController, :show
      resources "/company-categories", CompanyCategoriesController, except: [:new, :edit]
      get "/categories/stocks", StockController, :index
      resources "/categories/:category_id/stocks", StockController, except: [:new, :edit]
      resources "/user-stock-categories", UserStockCategoryController, except: [:new, :edit]
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bamboo_interview, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BambooInterviewWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
