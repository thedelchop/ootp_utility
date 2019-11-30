defmodule OOTPUtility.Leagues.ConferenceTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Leagues.Conference

  describe "import_changset" do
    test "it correctly writes the binary ID" do
      conference =
        Conference.build_attributes_for_import(%{
          sub_league_id: "2",
          name: "Test Conference",
          abbr: "TC",
          league_id: "1",
          designated_hitter: true
        })

      assert conference == %{
               name: "Test Conference",
               abbr: "TC",
               league_id: "1",
               id: "1-2",
               designated_hitter: true
             }
    end
  end
end
