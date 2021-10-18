defmodule Deduplicate.Users.SessionsTest do
  use Deduplicate.DataCase

  alias Deduplicate.Users.Sessions

  describe "create_session/1" do
    import Deduplicate.UsersFixtures

    setup do
      user = user_fixture()

      %{user: user}
    end

    test "with user struct, returns tuple", %{user: user} do
      assert {:ok, token, claims} = Sessions.create_session(user)
      assert is_binary(token)
      assert is_map(claims)
    end
  end
end
