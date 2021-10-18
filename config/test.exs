import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :deduplicate, Deduplicate.Repo,
  username: "postgres",
  password: "postgres",
  database: "deduplicate_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :deduplicate, DeduplicateWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8GUP3IWcglJdMY0LJugoih1CJC+3tZyOVQqisXvov/e1dmmnUyVIXZ78P170NSGP",
  server: false

# In test we don't send emails.
config :deduplicate, Deduplicate.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Configure authentication library
config :deduplicate, DeduplicateWeb.Guardian, issuer: "deduplicate", secret_key: "secret"
