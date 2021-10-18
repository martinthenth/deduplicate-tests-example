defmodule Deduplicate.Users.SessionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Deduplicate.Users.Sessions` context.
  """

  alias Deduplicate.Users.Sessions
  alias Deduplicate.Users.User

  @doc """
  Generate a job.
  """
  @spec session_fixture(%User{}, map) :: binary
  def session_fixture(user, _attrs \\ %{}) do
    {:ok, token, _claims} = Sessions.create_session(user)

    token
  end
end
