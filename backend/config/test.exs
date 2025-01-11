import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :jump_start, JumpStart.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "jump_start_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :jump_start, JumpStartWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "22camPwhVKED7U6Wwhu/FMgaHAeHeacQaBgQ5DzJW9tAMQw6TNs8rc333Z40XnSG",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :jump_start,
  google_api: [
    base_url: "http://localhost:4000"
  ],
  openai_api: [
    base_url: "http://localhost:4001"
  ]
