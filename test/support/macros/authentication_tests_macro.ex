defmodule DeduplicateWeb.AuthenticationTestsMacro do
  @moduledoc """
  This module defines macros for generating authentication
  tests for controller functions.
  """

  import ExUnit.Assertions

  @doc """
  This macro tests router paths that are inaccessible
  to unauthenticated and unauthorized users.
  """
  @spec test_user_authentication(atom, binary) :: any
  # Define macro.
  defmacro test_user_authentication(http_method, route_path) do
    # Mark the code as `generated`.
    quote generated: true do
      import Deduplicate.UsersFixtures
      import Deduplicate.Users.SessionsFixtures

      alias Deduplicate.Users

      # Make `http_method` and `route_path` available in the test blocks.
      @http_method unquote(http_method)
      @route_path unquote(route_path)

      # Implement the first test.
      test "user is not authenticated, renders error", %{conn: conn} do
        assert conn
               |> fetch_response(@http_method, @route_path)
               |> json_response(401)
      end

      # Implement the second test.
      test "user is banned, renders error", %{conn: conn} do
        user = user_fixture()
        token = session_fixture(user)

        Users.update_user(user, %{is_banned: true})

        assert conn
               |> put_req_header("authorization", token)
               |> fetch_response(@http_method, @route_path)
               |> json_response(401)
      end

      # Implement the third test.
      test "user is deleted, renders error", %{conn: conn} do
        user = user_fixture()
        token = session_fixture(user)

        Users.delete_user(user)

        assert conn
               |> put_req_header("authorization", token)
               |> fetch_response(@http_method, @route_path)
               |> json_response(401)
      end

      @doc false
      # Make an HTTP-request to the route `path`,
      # by pattern matching on the `http_method` variable.
      defp fetch_response(conn, :get, path), do: get(conn, path)
      defp fetch_response(conn, :post, path), do: post(conn, path)
    end
  end
end
