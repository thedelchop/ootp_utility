import Config

# Configure database
import_config "db.exs"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ootp_utility, OOTPUtilityWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: false,
  secret_key_base: "OI/yadtoYx1TU53+C1/Zddh+dVa5dqZk77ULWy9KEKs9RCTeflYsmHru9cSqLEDL"

# In test we don't send emails.
config :ootp_utility, OOTPUtility.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
