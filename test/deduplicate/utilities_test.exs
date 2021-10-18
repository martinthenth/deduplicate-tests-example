defmodule Deduplicate.UtilitiesTest do
  use Deduplicate.DataCase

  alias Deduplicate.Utilities

  describe "is_uuid?/1" do
    @valid_uuid Ecto.UUID.generate()
    @invalid_uuid "notanuuid"

    test "valid UUID, returns true" do
      assert Utilities.is_uuid?(@valid_uuid) === true
    end

    test "invalid UUID, returns false" do
      assert Utilities.is_uuid?(@invalid_uuid) === false
    end
  end
end
