defmodule Deduplicate.UsersTest do
  use Deduplicate.DataCase

  alias Deduplicate.Users
  alias Deduplicate.Users.User

  describe "get_user!/1" do
    import Deduplicate.UsersFixtures

    setup do
      user = user_fixture()

      %{user: user}
    end

    test "with `user_id`, returns the user", %{user: user} do
      assert Users.get_user!(user.user_id) == user
    end

    test "with non-existing `user_id`, raises `NoResultsError`" do
      id = Ecto.UUID.generate()

      assert_raise Ecto.NoResultsError, fn ->
        Users.get_user!(id)
      end
    end
  end

  describe "create_user/1" do
    @valid_attrs %{name: "some name", password: "12345678"}
    @empty_attrs %{}

    test "with valid attrs, creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)

      assert user.password_hash != nil
      assert user.name == @valid_attrs.name
    end

    test "with empty attrs, returns changeset" do
      assert {:error, changeset} = Users.create_user(@empty_attrs)
      assert %{name: _} = errors_on(changeset)
    end
  end

  describe "update_user/2" do
    import Deduplicate.UsersFixtures

    setup do
      user = user_fixture()

      %{user: user}
    end

    @valid_attrs %{name: "updated name", password: "updated password", is_banned: true}
    @empty_attrs %{}

    test "with valid attrs, updates the user", %{user: user} do
      assert {:ok, %User{} = updated_user} = Users.update_user(user, @valid_attrs)

      assert updated_user.name == @valid_attrs.name
      assert updated_user.password_hash != user.password_hash
      assert updated_user.is_banned == @valid_attrs.is_banned
    end

    test "with empty attrs, updates the user (without effect)", %{user: user} do
      assert {:ok, %User{} = updated_user} = Users.update_user(user, @empty_attrs)

      assert updated_user == user
    end
  end
end
