defmodule OOTPUtilityWeb.HelpersTest do
  use ExUnit.Case, async: true

  alias OOTPUtilityWeb.Helpers

  describe "friendly_date/1" do
    test "it formats the specified date as MM/DD/YYYY" do
      date = Date.new!(2021, 09, 12)

      assert Helpers.friendly_date(date) == "09/12/2021"
    end
  end
end
