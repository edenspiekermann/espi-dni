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
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :espi_dni, EspiDni.Plugs.RequireSlackToken,
  slack_token: "test-slack-token"

config :ueberauth, Ueberauth.Strategy.Slack.OAuth,
  client_id: "test",
  client_secret: "test"
