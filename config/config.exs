# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank,
  ecto_repos: [Bank.Repo]

# Configures the endpoint
config :bank, BankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5MSRbyKytlpcUY8Wcreni+8tEI8ZXBuxrCvUDnqPN2Jjno9lqFJs/76Vo8wIwcRY",
  render_errors: [view: BankWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Bank.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :rihanna,
  producer_postgres_connection: {Ecto, Bank.Repo}

config :money,
  default_currency: :BRL

config :bank, Bank.Guardian,
  issuer: "bank api",
  secret_key: "d9U/vOkX4YpnqjI8MLKmoLiqbRyGSYbaPT3ezHjILKEgN9cM6bRHfSbJ+MVP7BDn"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
