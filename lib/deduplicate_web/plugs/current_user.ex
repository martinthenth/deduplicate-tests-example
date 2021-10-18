defmodule DeduplicateWeb.Plugs.CurrentUser do
  @moduledoc """
  This Plug provides authorization and connection assigns for `User` data.
  """
  import Plug.Conn
  import DeduplicateWeb.Plugs.ErrorHelpers

  alias Deduplicate.Users.User

  @doc false
  @spec init(any) :: any
  def init(opts), do: opts

  @doc """
  Fetches a User struct and assigns it to the connection.

  Renders `ErrorView` if the authorization conditions are not met.

  ## Examples

      iex> call(conn, opts)
      %Plug.Conn{assigns: %{user: %User{}}}

      iex> call(conn, opts)
      %Plug.conn{status: :unauthorized}

  """
  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      %User{is_banned: false} = user ->
        conn
        |> assign(:current_user, user)

      _ ->
        render_error(conn, :unauthorized)
    end
  end
end
