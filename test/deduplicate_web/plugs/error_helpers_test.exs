defmodule DeduplicateWeb.Plugs.ErrorHelpersTest do
  use DeduplicateWeb.ConnCase

  alias DeduplicateWeb.Plugs.ErrorHelpers

  describe "render_error/2" do
    test "with `:bad_request`, renders error", %{conn: conn} do
      assert conn
             |> ErrorHelpers.render_error(:bad_request)
             |> json_response(400)
    end

    test "with `:unauthorized`, renders error", %{conn: conn} do
      assert conn
             |> ErrorHelpers.render_error(:unauthorized)
             |> json_response(401)
    end

    test "with `:forbidden`, renders error", %{conn: conn} do
      assert conn
             |> ErrorHelpers.render_error(:forbidden)
             |> json_response(403)
    end
  end
end
