defmodule DeduplicateWeb.GuardianTest do
  use Deduplicate.DataCase

  alias Deduplicate.Users.User

  describe "subject_for_token/2" do
    import Deduplicate.UsersFixtures

    setup do
      user = user_fixture()

      %{user: user}
    end

    test "with user struct, returns subject in success tuple", %{user: user} do
      assert {:ok, subject} = DeduplicateWeb.Guardian.subject_for_token(user, "claims")
      assert "User:" <> _ = subject
    end

    test "with invalid data, returns error tuple" do
      assert {:error, :unknown_resource} = DeduplicateWeb.Guardian.subject_for_token("user", "claims")
    end
  end

  describe "resource_from_claims/1" do
    import Deduplicate.UsersFixtures

    setup do
      user = user_fixture()

      %{user: user}
    end

    test "with valid data, returns user struct in success tuple", %{user: user} do
      subject = %{"sub" => "User:" <> user.user_id}

      assert {:ok, %User{}} = DeduplicateWeb.Guardian.resource_from_claims(subject)
    end

    test "with valid data, but user does not exist, returns error tuple" do
      uuid = Ecto.UUID.generate()
      subject = %{"sub" => "User:" <> uuid}

      assert {:error, :unauthorized} = DeduplicateWeb.Guardian.resource_from_claims(subject)
    end

    test "with invalid data, returns error tuple" do
      subject = "User:123"

      assert {:error, :invalid_claims} = DeduplicateWeb.Guardian.resource_from_claims(subject)
    end
  end
end
