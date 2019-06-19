# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ootp_utility,
  namespace: OOTPUtility,
  ecto_repos: [OOTPUtility.Repo]

# Configures the endpoint
config :ootp_utility, OOTPUtilityWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6IiwXVizhmLz04pcXH91kLbnQ7/BDcUQAGL31Akr2SwFIweT0PrbnLI6EhS2qcuq",
  render_errors: [view: OOTPUtilityWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OOTPUtility.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
