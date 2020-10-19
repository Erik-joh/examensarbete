# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :xarb,
  ecto_repos: [Xarb.Repo]

# Configures the endpoint
config :xarb, XarbWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ONcJDJjbf6Ni0FZw9Un1S7E4J4iHRm3BjpG/3rhro6AnUkxN6DasEroYB+zl3A3g",
  render_errors: [view: XarbWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Xarb.PubSub,
  live_view: [signing_salt: "fjLDv5yE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
