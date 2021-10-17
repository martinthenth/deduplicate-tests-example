defmodule Deduplicate.Users.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @primary_key {:user_id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :password, :string, virtual: true, redact: true
    field :password_hash, :string
    field :is_banned, :boolean

    timestamps()
  end

  @doc false
  @spec changeset(%User{}, map) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password, :is_banned])
    |> validate_required([:name])
    |> validate_length(:password, min: 8, max: 100)
    |> hash_password()
  end

  @doc false
  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> change(Argon2.add_hash(password))
    |> delete_change(:password)
  end

  defp hash_password(changeset), do: changeset
end
