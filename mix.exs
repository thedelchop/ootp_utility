defmodule OOTPUtility.MixProject do
  use Mix.Project

  def project do
    [
      app: :ootp_utility,
      version: "0.3.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers() ++ [:surface],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      releases: releases()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {OOTPUtility.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:csv, "~> 2.4"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:deep_merge, "~> 1.0"},
      {:ecto_sql, "~> 3.6"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:ex_heroicons, "~> 0.6.0"},
      {:ex_machina, "~> 2.7.0", only: [:dev, :test]},
      {:faker, github: "elixirs/faker", only: [:dev, :test]},
      {:floki, ">= 0.30.0", only: :test},
      {:flow, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:html_sanitize_ex, "~> 1.4"},
      {:libcluster, "~> 3.3"},
      {:libgraph, "~> 0.13"},
      {:jason, "~> 1.2"},
      {:morphix, "~> 0.8.0"},
      {:phoenix, "~> 1.6", override: true},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:phx_tailwind_generators, "~> 0.1.6"},
      {:plug_cowboy, "~> 2.5"},
      {:poolboy, "~> 1.5"},
      {:postgrex, ">= 0.0.0"},
      {:slugify, "~> 1.3"},
      {:snapshy, "~> 0.2.4", only: :test},
      {:surface, "~> 0.7"},
      {:surface_formatter, "~> 0.7.5", only: [:dev, :test]},
      {:swoosh, "~> 1.3"},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:timex, ">= 3.7.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end

  defp releases do
    [
      ootp_utility: [
        include_executables_for: [:unix],
        cookie: "LjohwnSJp04uz6ucDTWt4tn9gNYVr7BmyLILKFsTCkBiWxZKp6_8gA=="
      ]
    ]
  end
end
