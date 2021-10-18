defmodule DeduplicateWeb.Plugs.IsCurrentUserTest do
  use DeduplicateWeb.ConnCase
  use Plug.Test

  alias DeduplicateWeb.Plugs.IsCurrentUser

  describe "call/2" do
    import Deduplicate.UsersFixtures
    import Deduplicate.Users.SessionsFixtures

    setup do
      user = user_fixture()
      token = session_fixture(user)

      %{user: user, token: token}
    end

    @invalid_user_id "123"

    test "with `user_id` of current user, returns conn", %{token: token, user: user} do
      params = %{"user_id" => user.user_id}

      conn =
        conn(:get, "/", params)
        |> put_req_header("authorization", token)
        |> assign(:current_user, user)
        |> Plug.run([
          &IsCurrentUser.call(&1, [])
        ])

      assert conn.status == nil
    end

    test "with `user_id` not of current user, renders error", %{user: user, token: token} do
      params = %{"user_id" => Ecto.UUID.generate()}

      conn =
        conn(:get, "/", params)
        |> put_req_header("authorization", token)
        |> assign(:current_user, user)
        |> Plug.run([
          &IsCurrentUser.call(&1, [])
        ])

      assert json_response(conn, 403)
      assert json_response(conn, 403)["errors"] != nil
    end

    test "with invalid `user_id`, renders error", %{user: user, token: token} do
      params = %{"user_id" => @invalid_user_id}

      conn =
        conn(:get, "/", params)
        |> put_req_header("authorization", token)
        |> assign(:current_user, user)
        |> Plug.run([
          &IsCurrentUser.call(&1, [])
        ])

      assert json_response(conn, 403)
      assert json_response(conn, 403)["errors"] != nil
    end

    test "with missing `user_id`, renders error", %{user: user, token: token} do
      conn =
        conn(:get, "/")
        |> put_req_header("authorization", token)
        |> assign(:current_user, user)
        |> Plug.run([
          &IsCurrentUser.call(&1, [])
        ])

      assert json_response(conn, 400)
      assert json_response(conn, 400)["errors"] != nil
    end
  end
end
