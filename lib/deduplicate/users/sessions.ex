defmodule Deduplicate.Users.Sessions do
  @moduledoc """
  The Deduplicate.Sessions context.
  """

  alias Deduplicate.Users.User
  alias DeduplicateWeb.Guardian

  @doc """
  Creates a session for the user.

  ## Examples

      iex> create_session(user)
      {:ok, token, claims}

      iex> create_session(user)
      {:error, :unknown_resource}

  """
  @spec create_session(%User{}, map) :: {:ok, binary, map} | {:error, any}
  def create_session(%User{} = user, _claims \\ %{}), do: Guardian.encode_and_sign(user)
end
