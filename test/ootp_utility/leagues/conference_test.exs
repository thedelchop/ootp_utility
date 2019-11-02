defmodule OOTPUtility.Leagues.ConferenceTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Leagues.Conference

  describe "import_changset" do
    test "it correctly writes the binary ID" do
      conference =
        Conference.import_changeset(%{
          name: "Test Conference",
          abbr: "TC",
          league_id: "1",
          sub_league_id: "2",
          designated_hitter: true
        })

      attrs =
        conference
        |> Map.from_struct()
        |> Map.take([:id, :name, :abbr, :league_id, :designated_hitter])

      assert attrs == %{
               name: "Test Conference",
               abbr: "TC",
               league_id: "1",
               id: "1-2",
               designated_hitter: true
             }
    end
  end
end