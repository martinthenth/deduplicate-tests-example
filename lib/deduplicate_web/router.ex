defmodule DeduplicateWeb.Router do
  use DeduplicateWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes.
  scope "/api", DeduplicateWeb do
    pipe_through :api

    post "/users/create", UserController, :create

  end
end
