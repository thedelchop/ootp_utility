use Mix.Config

defaults = [
  hostname: "localhost",
  pool_size: 10,
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
      Keyword.merge(defaults, database: "ootp_utility_test", pool: Ecto.Adapters.SQL.Sandbox)

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
