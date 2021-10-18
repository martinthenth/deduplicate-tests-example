defmodule DeduplicateWeb.Plugs.CurrentUserTest do
  use DeduplicateWeb.ConnCase
  use Plug.Test

  alias Deduplicate.Users
  alias DeduplicateWeb.Plugs.GuardianPipeline
  alias DeduplicateWeb.Plugs.CurrentUser

  describe "call/2" do
    import Deduplicate.UsersFixtures
    import Deduplicate.Users.SessionsFixtures

    setup do
      user = user_fixture()
      token = session_fixture(user)

      %{user: user, token: token}
    end

    @invalid_token "faketoken"

    test "with token of valid user, returns conn", %{token: token, user: user} do
      conn =
        conn(:get, "/")
        |> put_req_header("authorization", token)
        |> Plug.run([
          &GuardianPipeline.call(&1, []),
          &CurrentUser.call(&1, [])
        ])

      assert conn.status == nil
      assert conn.assigns.current_user == user
    end

    test "with token of banned user, renders error", %{user: user, token: token} do
      Users.update_user(user, %{is_banned: true})

      conn =
        conn(:get, "/")
        |> put_req_header("authorization", token)
        |> Plug.run([
          &GuardianPipeline.call(&1, []),
          &CurrentUser.call(&1, [])
        ])

      assert json_response(conn, 401)
      assert json_response(conn, 401)["errors"] != nil
    end

    test "with token of deleted user, renders error", %{user: user, token: token} do
      Users.delete_user(user)

      conn =
        conn(:get, "/")
        |> put_req_header("authorization", token)
        |> Plug.run([
          &GuardianPipeline.call(&1, []),
          &CurrentUser.call(&1, [])
        ])

      assert json_response(conn, 401)
      assert json_response(conn, 401)["errors"] != nil
    end

    test "with invalid token, renders error" do
      conn =
        conn(:get, "/")
        |> put_req_header("authorization", @invalid_token)
        |> Plug.run([
          &GuardianPipeline.call(&1, []),
          &CurrentUser.call(&1, [])
        ])

      assert json_response(conn, 401)
      assert json_response(conn, 401)["errors"] != nil
    end

    test "with missing token, renders error" do
      conn =
        conn(:get, "/")
        |> Plug.run([
          &GuardianPipeline.call(&1, []),
          &CurrentUser.call(&1, [])
        ])

      assert json_response(conn, 401)
      assert json_response(conn, 401)["errors"] != nil
    end
  end
end
