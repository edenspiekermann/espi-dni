use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :espi_dni, EspiDni.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :espi_dni, EspiDni.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "espi_dni_test",
  hostname: System.get_env("DATABASE_HOST") || "localhost",
  username: System.get_env("DATABASE_USER") || "postgres",
  password: System.get_env("DATABASE_PASSWORD"),
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 50_0000

config :rollbax,
  access_token: "placeholder",
  environment: "test"

# Set rollbar erorrs to just log locally
config :rollbax, enabled: :log

# configure exq for background jobs with redis
config :exq,
  host: System.get_env("REDIS_HOST") || "localhost",
  port: 6379,
  namespace: "exq-test",
  concurrency: 1000,
  queues: ["default"]

config :espi_dni, EspiDni.Plugs.RequireSlackToken,
  slack_token: "test-slack-token"

config :ueberauth, Ueberauth.Strategy.Slack.OAuth,
  client_id: "test",
  client_secret: "test"

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "test",
  client_secret: "test"
