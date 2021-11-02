use Mix.Config

defaults = [
  hostname: "localhost",
  pool_size: 450,
  migration_primary_key: [name: :id, type: :string]
]

auth_config =
  if System.get_env("DATABASE_USERNAME") do
    [
      username: System.get_env("DATABASE_USERNAME"),
      password: System.get_env("DATABASE_PASSWORD")
    ]
  else
    []
  end

db_config =
  case Mix.env() do
    :dev ->
      Keyword.merge(defaults,
        database: "ootp_utility_dev",
        show_sensitive_data_on_connection_error: true
      )

    :test ->
      # The MIX_TEST_PARTITION environment variable can be used
      # to provide built-in test partitioning in CI environment.
      # Run `mix help test` for more information.
      Keyword.merge(defaults,
        database: "ootp_utility_test#{System.get_env("MIX_TEST_PARTITION")}",
        pool: Ecto.Adapters.SQL.Sandbox
      )

    _ ->
      database_url =
        System.get_env("DATABASE_URL") ||
          raise """
          environment variable DATABASE_URL is missing.
          For example: ecto://USER:PASS@HOST/DATABASE
          """

      Keyword.merge(defaults,
        ssl: true,
        url: database_url,
        pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
      )
  end

config :ootp_utility, OOTPUtility.Repo, Keyword.merge(db_config, auth_config)
