defmodule DeduplicateWeb.Plugs.ErrorHelpers do
  @moduledoc """
  Conveniences for rendering error messages in Plugs.
  """
  use DeduplicateWeb, :controller

  alias DeduplicateWeb.ErrorView

  @spec render_error(Plug.Conn.t(), atom) :: Plug.Conn.t()
  def render_error(conn, :bad_request) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json")
    |> halt()
  end

  def render_error(conn, :unauthorized) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json")
    |> halt()
  end

  def render_error(conn, :forbidden) do
    conn
    |> put_status(:forbidden)
    |> put_view(ErrorView)
    |> render("403.json")
    |> halt()
  end
end
