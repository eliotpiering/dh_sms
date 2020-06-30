# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dh_sms,
  ecto_repos: [DhSms.Repo]

# Configures the endpoint
config :dh_sms, DhSmsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2ijA7DmMWojYlWH4FmEHmPQO41PJkJvNEVF84JBzE4cKMrZWF1NIb4tfQ0IYQFRJ",
  render_errors: [view: DhSmsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DhSms.PubSub,
  live_view: [signing_salt: "e2FwsPEi"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
