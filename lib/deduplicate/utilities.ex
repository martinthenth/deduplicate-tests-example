defmodule Deduplicate.Utilities do
  @moduledoc """
  The Utilities context.
  """

  @doc """
  Checks the given string is in the UUID format.

  ## Examples

      iex> is_uuid?("0038b501-7da6-4f81-a027-bb85d2e6f863")
      true

      iex> is_uuid?("string")
      false

  """
  @spec is_uuid?(<<_::288>> | binary) :: boolean
  def is_uuid?(<<_::288>> = string) do
    case Ecto.UUID.dump(string) do
      {:ok, _binary} -> true
      :error -> false
    end
  end

  def is_uuid?(_), do: false
end
