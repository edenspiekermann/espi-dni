defmodule EspiDni.Router do
  use EspiDni.Web, :router
  use Plug.ErrorHandler

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug EspiDni.Plugs.SetSessionData, repo: EspiDni.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :slack do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :put_secure_browser_headers
    plug EspiDni.Plugs.ParseSlackPayload
    plug EspiDni.Plugs.RequireSlackToken
    plug EspiDni.Plugs.SetSlackUser, repo: EspiDni.Repo
  end

  scope "/", EspiDni do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/setup", SetupController, :index
    put "/setup", SetupController, :update
    get "/preferences", PreferenceController, :index
    put "/preferences", PreferenceController, :update

    resources "/teams", TeamController
    resources "/users", UserController
    resources "/articles", ArticleController
  end

  scope "/slack", EspiDni do
    pipe_through :slack

    post "/articles/new", SlackArticleController, :new
    post "/messages/new", SlackMessageController, :new
  end

  scope "/auth", EspiDni do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", EspiDni do
  #   pipe_through :api
  # end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    Rollbax.report(kind, reason, stacktrace)
  end
end
