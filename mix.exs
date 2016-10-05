defmodule EspiDni.Mixfile do
  use Mix.Project

  def project do
    [app: :espi_dni,
     version: "0.0.1",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {EspiDni, []},
     applications: [
       :phoenix,
       :phoenix_html,
       :cowboy,
       :logger,
       :gettext,
       :phoenix_ecto,
       :postgrex,
       :slack,
       :ueberauth_slack,
       :ueberauth_google,
       :timex,
       :gproc,
       :exq,
       :rollbax
     ]
   ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:phoenix_html, "~> 2.7"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:slack, "~> 0.7.0"},
     {:ueberauth_slack, "~> 0.4"},
     {:ueberauth_google, git: "https://github.com/ueberauth/ueberauth_google"},
     {:websocket_client, git: "https://github.com/jeremyong/websocket_client"},
     {:cowboy, "~> 1.0"},
     {:timex, "~> 3.0"},
     {:gproc, "~> 0.6.1"},
     {:rollbax, "~> 0.7.0"},
     {:exq, git: "https://github.com/akira/exq.git"},
     {:credo, "~> 0.4", only: [:dev, :test]}
   ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
