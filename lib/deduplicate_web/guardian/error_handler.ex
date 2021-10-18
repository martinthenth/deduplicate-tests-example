defmodule DeduplicateWeb.Guardian.ErrorHandler do
  use DeduplicateWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  @spec auth_error(Plug.Conn.t(), tuple, keyword) :: Plug.Conn.t()
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(DeduplicateWeb.ErrorView)
    |> render("401.json")
  end
end
