defmodule Librecov.Router do
  use Librecov.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Librecov.Plug.FetchUser)
    plug(Librecov.Plug.ForcePasswordInitialize)
    plug(NavigationHistory.Tracker, excluded_paths: ~w(/login /users/new))

    if Application.get_env(:librecov, :auth)[:enable] do
      plug(:basic_auth, use_config: {:librecov, :auth})
    end
  end

  pipeline :anonymous_only do
    plug(Librecov.Plug.AnonymousOnly)
  end

  pipeline :authenticate do
    plug(Librecov.Plug.Authentication)
  end

  pipeline :authenticate_admin do
    plug(Librecov.Plug.Authentication, admin: true)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(OpenApiSpex.Plug.PutApiSpec, module: Librecov.Web.ApiSpec)
  end

  scope "/api/v1", Librecov.Api.V1, as: :api_v1 do
    pipe_through(:api)

    # forward("/github_webhook", Librecov.Plug.Github, [], )
    # post("/github_webhook", GithubController, :webhook)
    resources("/jobs", JobController, only: [:create])
  end

  scope "/", Librecov do
    pipe_through(:browser)

    get("/projects/:project_id/badge.:format", ProjectController, :badge, as: :project_badge)
  end

  scope "/", Librecov do
    pipe_through(:api)
    post("/webhook", WebhookController, :create)
  end

  scope "/", Librecov do
    pipe_through(:browser)
    pipe_through(:anonymous_only)

    get("/login", AuthController, :login)
    post("/login", AuthController, :make_login)
    resources("/users", UserController, only: [:new, :create])
    get("/users/confirm", UserController, :confirm)
    get("/profile/password/reset_request", ProfileController, :reset_password_request)
    post("/profile/password/reset_request", ProfileController, :send_reset_password)
    get("/profile/password/reset", ProfileController, :reset_password)
    put("/profile/password/reset", ProfileController, :finalize_reset_password)
  end

  scope "/", Librecov do
    pipe_through(:browser)
    pipe_through(:authenticate)

    delete("/logout", AuthController, :logout)

    get("/", ProjectController, :index)

    get("/profile", ProfileController, :show)
    put("/profile", ProfileController, :update)
    get("/profile/password/edit", ProfileController, :edit_password)
    put("/profile/password", ProfileController, :update_password)

    resources("/projects", ProjectController)
    resources("/builds", BuildController, only: [:show])
    resources("/files", FileController, only: [:show])

    resources("/jobs", JobController, only: [:show])
  end

  scope "/admin", Librecov.Admin, as: :admin do
    pipe_through(:browser)
    pipe_through(:authenticate_admin)

    get("/", DashboardController, :index)

    resources("/users", UserController)
    resources("/projects", ProjectController, only: [:index, :show])
    get("/settings", SettingsController, :edit)
    put("/settings", SettingsController, :update)
  end
end
