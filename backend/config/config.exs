# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :jump_start,
  ecto_repos: [JumpStart.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :jump_start, JumpStartWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: JumpStartWeb.ErrorHTML, json: JumpStartWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: JumpStart.PubSub,
  live_view: [signing_salt: "sQI54mrz"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  jump_start: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  jump_start: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :jump_start,
  google_api: [
    base_url: "https://www.googleapis.com"
  ],
  openai_api: [
    base_url: "https://api.openai.com"
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
