defmodule OOTPUtility.Leagues.LeagueTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.League

  describe "import_changset" do
    test "it correctly writes the binary ID" do
      league_attrs =
        League.build_attributes_for_import(%{
          league_id: "1",
          name: "Test League",
          abbr: "TL",
          current_date: "2019-09-25",
          historical_year: 40,
          league_level: "Major",
          league_state: "Offseason",
          logo_filename: "/path/logo_file.png",
          season_year: 3,
          start_date: "2030-04-05"
        })

      assert league_attrs == %{
               id: "1",
               name: "Test League",
               abbr: "TL",
               current_date: ~D[2019-09-25],
               historical_year: 40,
               league_level: "Major",
               league_state: "Offseason",
               logo_filename: "/path/logo_file.png",
               season_year: 3,
               start_date: ~D[2030-04-05]
             }
    end
  end
end
