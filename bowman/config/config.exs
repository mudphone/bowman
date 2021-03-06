# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bowman,
  ecto_repos: [Bowman.Repo]

# Configures the endpoint
config :bowman, BowmanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1OTMU9x3KaOtN1C0oPp0j+ABVuf1qC7Z5n4YB1eHHIg0E7GibcJKxQ7KtoIagO1+",
  render_errors: [view: BowmanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bowman.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "bWY5zvJJJTVjKJvc0MSUuZuO5UrMyj6q~"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Enable writing LiveView templates
config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
