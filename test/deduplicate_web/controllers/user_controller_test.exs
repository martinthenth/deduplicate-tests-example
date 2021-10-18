defmodule DeduplicateWeb.UserControllerTest do
  use DeduplicateWeb.ConnCase

  import Deduplicate.UsersFixtures

  alias Deduplicate.Users

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create/2" do
    @valid_params %{user: %{name: "some name", password: "some password"}}
    @missing_params %{}

    test "with valid params, creates a user, renders the user", %{conn: conn} do
      path = Routes.user_path(conn, :create)
      conn = post(conn, path, @valid_params)

      assert %{"user" => _} = json_response(conn, 201)["data"]
    end

    test "with missing params, renders error", %{conn: conn} do
      path = Routes.user_path(conn, :create)
      conn = post(conn, path, @missing_params)

      assert json_response(conn, 400)
    end
  end

  describe "update/2" do
    import Deduplicate.UsersFixtures
    import Deduplicate.Users.SessionsFixtures

    setup do
      user = user_fixture()
      token = session_fixture(user)

      %{user: user, token: token}
    end

    @valid_params %{user: %{name: "updated name", password: "updated password", is_banned: true}}
    @missing_params %{}

    test "with valid params, updates the user, renders the user", %{
      conn: conn,
      user: user,
      token: token
    } do
      path = Routes.user_path(conn, :update, user.user_id)

      conn =
        conn
        |> put_req_header("authorization", token)
        |> post(path, @valid_params)

      assert %{"user" => _} = json_response(conn, 202)["data"]

      # Verify user is updated with given data.
      updated_user = Users.get_user!(user.user_id)

      assert updated_user.password_hash != user.password_hash
      assert updated_user.name == @valid_params.user.name
      assert updated_user.is_banned == @valid_params.user.is_banned
    end

    test "with missing params, renders error", %{conn: conn, user: user, token: token} do
      path = Routes.user_path(conn, :update, user.user_id)

      conn =
        conn
        |> put_req_header("authorization", token)
        |> post(path, @missing_params)

      assert json_response(conn, 400)

      # Verify user was not updated.
      assert Users.get_user!(user.user_id) == user
    end
  end

  describe "delete/2" do
    import Deduplicate.UsersFixtures
    import Deduplicate.Users.SessionsFixtures

    setup do
      user = user_fixture()
      token = session_fixture(user)

      %{user: user, token: token}
    end

    test "with valid params, deletes the user, renders the user", %{
      conn: conn,
      user: user,
      token: token
    } do
      path = Routes.user_path(conn, :delete, user.user_id)

      conn =
        conn
        |> put_req_header("authorization", token)
        |> post(path)

      assert %{"user" => _} = json_response(conn, 202)["data"]

      # Verify user is deleted.
      assert_raise Ecto.NoResultsError, fn ->
        Users.get_user!(user.user_id)
      end
    end
  end
end
