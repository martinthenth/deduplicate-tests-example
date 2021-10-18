defmodule DeduplicateWeb.UserAuthorizationTestsMacro do
  @moduledoc """
  This module defines macros for generating `User` authorization
  tests for controller functions.
  """

  import ExUnit.Assertions

  @doc """
  This macro tests router paths that are inaccessible
  to authenticated user that are not the target `User`.
  """
  @spec test_user_authorization(atom, binary) :: any
  # Define macro.
  defmacro test_user_authorization(http_method, route_path) do
    # Mark the code as `generated`.
    quote generated: true do
      import Deduplicate.UsersFixtures
      import Deduplicate.Users.SessionsFixtures

      alias Deduplicate.Users

      # Make `http_method` and `route_path` available in the test blocks.
      @http_method unquote(http_method)
      @route_path unquote(route_path)
      @foreign_user_id Ecto.UUID.generate()
      @invalid_user_id "123"

      # Implement the first test.
      test "with `user_id` is not current user's `user_id`, renders error", %{conn: conn} do
        user = user_fixture()
        token = session_fixture(user)

        injected_path = String.replace(@route_path, "user_id", @foreign_user_id)

        assert conn
               |> put_req_header("authorization", token)
               |> fetch_response(@http_method, injected_path)
               |> json_response(403)
      end

      # Implement the first test.
      test "with invalid `user_id`, renders error", %{conn: conn} do
        user = user_fixture()
        token = session_fixture(user)

        injected_path = String.replace(@route_path, "user_id", @invalid_user_id)

        assert conn
               |> put_req_header("authorization", token)
               |> fetch_response(@http_method, injected_path)
               |> json_response(400)
      end

      @doc false
      # Make an HTTP-request to the route `path`,
      # by pattern matching on the `http_method` variable.
      defp fetch_response(conn, :get, path), do: get(conn, path)
      defp fetch_response(conn, :post, path), do: post(conn, path)
    end
  end
end
