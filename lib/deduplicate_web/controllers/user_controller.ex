defmodule DeduplicateWeb.UserController do
  use DeduplicateWeb, :controller

  alias Deduplicate.Users
  alias Deduplicate.Users.User

  action_fallback DeduplicateWeb.FallbackController

  @doc """
  Creates a user with the given params.
  """
  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t() | {:error, Ecto.Changeset.t() | atom}
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = created_user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: created_user)
    end
  end

  def create(_conn, _params), do: {:error, :bad_request}

  @doc """
  Updates a user with the given params.
  """
  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t() | {:error, Ecto.Changeset.t() | atom}
  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    with {:ok, %User{} = updated_user} <- Users.update_user(user, user_params) do
      conn
      |> put_status(:accepted)
      |> render("show.json", user: updated_user)
    end
  end

  def update(_conn, _params), do: {:error, :bad_request}

  @doc """
  Deletes a user with the given params.
  """
  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t() | {:error, Ecto.Changeset.t() | atom}
  def delete(conn, %{"user_id" => _}) do
    user = conn.assigns.current_user

    with {:ok, %User{} = deleted_user} <- Users.delete_user(user) do
      conn
      |> put_status(:accepted)
      |> render("show.json", user: deleted_user)
    end
  end

  def delete(_conn, _params), do: {:error, :bad_request}
end
