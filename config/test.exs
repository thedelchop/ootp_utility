use Mix.Config

# Configure your database
config :ootp_utility, OOTPUtility.Repo,
  database: "ootp_utility_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ootp_utility, OOTPUtilityWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
