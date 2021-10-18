defmodule DeduplicateWeb.UserControllerTest do
  use DeduplicateWeb.ConnCase

  import Deduplicate.UsersFixtures

  alias Deduplicate.Users.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create/2" do
    @valid_params %{
      user: %{
        name: "some name",
        password: "some password"
      }
    }
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
end
