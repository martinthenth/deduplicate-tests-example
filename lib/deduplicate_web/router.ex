defmodule DeduplicateWeb.Router do
  use DeduplicateWeb, :router

  alias DeduplicateWeb.Plugs

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Plugs.GuardianPipeline
    plug Plugs.CurrentUser
  end

  pipeline :is_current_user do
    plug Plugs.IsCurrentUser
  end

  # Public routes.
  scope "/api", DeduplicateWeb do
    pipe_through :api

    post "/users/create", UserController, :create
  end

  # Authenticated routes.
  scope "/api/users/:user_id", DeduplicateWeb do
    pipe_through [:api, :authenticated, :is_current_user]

    post "/update", UserController, :update
    post "/delete", UserController, :delete
  end
end
