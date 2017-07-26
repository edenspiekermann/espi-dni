use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :espi_dni, EspiDni.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

# Watch static and templates for browser reloading.
config :espi_dni, EspiDni.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :espi_dni, EspiDni.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "espi_dni_dev",
  hostname: System.get_env("DATABASE_HOST") || "localhost",
  username: System.get_env("DATABASE_USER") || "postgres",
  password: System.get_env("DATABASE_PASSWORD"),
  pool_size: 10

config :rollbax,
  access_token: "placeholder",
  environment: "development"

# Set rollbar erorrs to just log locally
config :rollbax, enabled: :log

# configure exq for background jobs with redis
config :exq,
  host: System.get_env("REDIS_HOST") || "localhost",
  port: 6379,
  namespace: "exq",
  concurrency: 1000,
  queues: ["default"]

# Use add local dev secrets
import_config "dev.secret.exs"

