defmodule OOTPUtilityWeb.Helpers do
  def friendly_date(date) do
    Timex.format!(date, "{0M}/{D}/{YYYY}")
  end
end
