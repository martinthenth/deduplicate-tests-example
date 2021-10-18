defmodule DeduplicateWeb.Guardian do
  use Guardian, otp_app: :deduplicate

  alias Deduplicate.Users
  alias Deduplicate.Users.User

  @doc """
  Generates the subject field for JSON Web Tokens from a User{}.
  """
  @spec subject_for_token(%User{}, any) :: {:ok, binary} | {:error, atom}
  def subject_for_token(%User{} = resource, _claims) do
    {:ok, "User:#{resource.user_id}"}
  end

  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

  @doc """
  Fetches a User using the subject field of a JSON Web Token.
  """
  @spec resource_from_claims(map) :: {:ok, %User{}} | {:error, atom}
  def resource_from_claims(%{"sub" => "User:" <> user_id}) do
    case Users.get_user(user_id) do
      %User{} = user -> {:ok, user}
      nil -> {:error, :unauthorized}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :invalid_claims}
  end
end
