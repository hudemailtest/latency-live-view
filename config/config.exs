# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :latency_live,
  ecto_repos: [LatencyLive.Repo]

# Configures the endpoint
config :latency_live, LatencyLiveWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Y7/FOsjLSXfbglZ99B7D3E6eDSOLyEMMAd/USqtjsnmmLqu2Fqya2xPDCy9CkMqK",
  render_errors: [view: LatencyLiveWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LatencyLive.PubSub,
  live_view: [signing_salt: "yDsVEQKM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
