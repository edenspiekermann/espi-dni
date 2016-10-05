# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :espi_dni, EspiDni.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "nD0DcT3en9UJdAw2lyzb1RQH0ZpEY4Pg//5fPTi9jjkL6PG004IttraWiJPOEzQF",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: EspiDni.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :espi_dni, ecto_repos: [EspiDni.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :ueberauth, Ueberauth,
  providers: [
    slack: { Ueberauth.Strategy.Slack, [
        default_scope: "bot,commands,users:read,team:read"
      ]
    },
    google: { Ueberauth.Strategy.Google, [
        default_scope: "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/analytics",
        approval_prompt: "force",
        access_type: "offline"
      ]
    }
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
