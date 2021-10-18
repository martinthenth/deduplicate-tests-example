defmodule DeduplicateWeb.Plugs.IsCurrentUser do
  @moduledoc """
  This Plug provides authorization for `User` data.
  """
  import DeduplicateWeb.Plugs.ErrorHelpers

  alias Deduplicate.Utilities

  @doc false
  @spec init(any) :: any
  def init(opts), do: opts

  @doc """
  Fetches an Employer struct and assigns it to the connection.

  Renders `ErrorView` if the authorization conditions are not met.

  ## Examples

      iex> call(conn, opts)
      %Plug.Conn{assigns: %{employer: %Employer{}}}

      iex> call(conn, opts)
      %Plug.conn{status: :forbidden}

  """
  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(%{params: %{"user_id" => user_id}} = conn, _opts) do
    current_user = conn.assigns.current_user

    with true <- Utilities.is_uuid?(user_id),
         true <- current_user.user_id == user_id do
      conn
    else
      false -> render_error(conn, :forbidden)
    end
  end

  def call(conn, _opts), do: render_error(conn, :bad_request)
end
