defmodule Deduplicate.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :user_id, :binary_id, primary_key: true
      add :name, :string
      add :password_hash, :string
      add :is_banned, :boolean, default: false

      timestamps()
    end
  end
end
