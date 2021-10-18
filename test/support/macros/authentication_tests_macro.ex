defmodule DeduplicateWeb.AuthenticationTestsMacro do
  @moduledoc """
  This module defines helper functions for testing authentication
  and authorization requirements for controller actions.
  """

  import ExUnit.Assertions

  @doc """
  This macro tests router paths that are inaccessible
  to unauthenticated and unauthorized users.
  """
  @spec test_user_authentication(atom, binary) :: any
  defmacro test_user_authentication(action, path) do
    quote generated: true do
      import Deduplicate.UsersFixtures
      import Deduplicate.Users.SessionsFixtures

      alias Deduplicate.Users

      @action unquote(action)
      @path unquote(path)

      test "user is not authenticated, renders error", %{conn: conn} do
        assert conn
               |> fetch_response(@action, @path)
               |> json_response(401)
      end

      test "user is banned, renders error", %{conn: conn} do
        user = user_fixture()
        token = session_fixture(user)

        Users.update_user(user, %{is_banned: true})

        assert conn
               |> put_req_header("authorization", token)
               |> fetch_response(@action, @path)
               |> json_response(401)
      end

      test "user is deleted, renders error", %{conn: conn} do
        user = user_fixture()
        token = session_fixture(user)

        Users.delete_user(user)

        assert conn
               |> put_req_header("authorization", token)
               |> fetch_response(@action, @path)
               |> json_response(401)
      end

      @doc false
      defp fetch_response(conn, :get, path), do: get(conn, path)
      defp fetch_response(conn, :post, path), do: post(conn, path)
    end
  end
end
