defmodule OOTPUtility.Repo do
  use Ecto.Repo,
    otp_app: :ootp_utility,
    adapter: Ecto.Adapters.Postgres
end
