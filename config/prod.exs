use Mix.Config

config :espi_dni, EspiDni.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "espi-dni.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

# Database config
config :espi_dni, EspiDni.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :rollbax,
  access_token: System.get_env("ROLLBAR_TOKEN"),
  environment: "production"

config :espi_dni, EspiDni.Plugs.RequireSlackToken,
  slack_token: System.get_env("SLACK_TOKEN")

config :ueberauth, Ueberauth.Strategy.Slack.OAuth,
  client_id: System.get_env("SLACK_CLIENT_ID") ,
  client_secret: System.get_env("SLACK_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")
