# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :exarb_app,
  ecto_repos: [ExarbApp.Repo]

# Configures the endpoint
config :exarb_app, ExarbAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dSL+ZI2ukcPkvHxshbT5so8dtHaeb9b/wqEI7ayEYwu2zWOkI9bSCD5qROPG2Cor",
  render_errors: [view: ExarbAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExarbApp.PubSub,
  live_view: [signing_salt: "PE9/b2k8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
