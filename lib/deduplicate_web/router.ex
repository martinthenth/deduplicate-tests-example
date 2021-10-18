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

  # Public routes.
  scope "/api", DeduplicateWeb do
    pipe_through :api

    post "/users/create", UserController, :create
  end

  # Authenticated routes.
  scope "/api/users/:user_id", DeduplicateWeb do
    pipe_through [:api, :authenticated]

    post "/update", UserController, :update
    post "/delete", UserController, :delete
  end
end
