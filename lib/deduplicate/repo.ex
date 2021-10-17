defmodule Deduplicate.Repo do
  use Ecto.Repo,
    otp_app: :deduplicate,
    adapter: Ecto.Adapters.Postgres
end
