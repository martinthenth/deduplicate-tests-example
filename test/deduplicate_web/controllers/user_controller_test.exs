defmodule DeduplicateWeb.UserControllerTest do
  use DeduplicateWeb.ConnCase

  import Deduplicate.UsersFixtures
  import Deduplicate.Users.SessionsFixtures
  import DeduplicateWeb.AuthenticationTestsMacro
  import DeduplicateWeb.UserAuthorizationTestsMacro

  alias Deduplicate.Users

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create/2" do
    @valid_params %{user: %{name: "some name", password: "some password"}}
    @missing_params %{}

    # Regular test.
    test "with valid params, creates a user, renders the user", %{conn: conn} do
      path = Routes.user_path(conn, :create)
      conn = post(conn, path, @valid_params)

      assert %{"user" => _} = json_response(conn, 201)["data"]
    end

    # Regular test.
    test "with missing params, renders error", %{conn: conn} do
      path = Routes.user_path(conn, :create)
      conn = post(conn, path, @missing_params)

      assert json_response(conn, 400)
    end

    # Authentication tests macro is not necessary for `create/2`.
    # User authorization tests macro is not necessary for `create/2`.
  end

  describe "update/2" do
    # The test setup block.
    setup do
      user = user_fixture()
      token = session_fixture(user)

      %{user: user, token: token}
    end

    @valid_params %{user: %{name: "updated name", password: "updated password", is_banned: true}}
    @missing_params %{}

    # Regular test.
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
    end

    # Regular test.
    test "with missing params, renders error", %{conn: conn, user: user, token: token} do
      path = Routes.user_path(conn, :update, user.user_id)

      conn =
        conn
        |> put_req_header("authorization", token)
        |> post(path, @missing_params)

      assert json_response(conn, 400)
    end

    # Implement authentication test macro.
    path = Routes.user_path(@endpoint, :update, "user_id")

    test_user_authentication(:post, path)
    test_user_authorization(:post, path)
  end

  describe "delete/2" do
    # The test setup block.
    setup do
      user = user_fixture()
      token = session_fixture(user)

      %{user: user, token: token}
    end

    # Regular test.
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
    end

    # Implement authentication tests macro.
    path = Routes.user_path(@endpoint, :delete, "user_id")

    test_user_authentication(:post, path)
    test_user_authorization(:post, path)
  end
end
