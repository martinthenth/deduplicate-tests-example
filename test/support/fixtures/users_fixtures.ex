defmodule Deduplicate.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Deduplicate.Users` context.
  """

  alias Deduplicate.Users
  alias Deduplicate.Users.User

  @spec user_fixture(map) :: %User{}
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{name: "some name"})
      |> Users.create_user()

    user
  end
end
