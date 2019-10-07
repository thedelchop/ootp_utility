defmodule OOTPUtility.Leagues.LeagueTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.League

  describe "import_changset" do
    test "it correctly writes the binary ID" do
      league =
        League.import_changeset(%{
          league_id: "1",
          name: "Test League",
          abbr: "TL",
          current_date: ~D[2019-09-25],
          historical_year: 40,
          league_level: "Major",
          league_state: "Offseason",
          logo_filename: "/path/logo_file.png",
          season_year: 3,
          start_date: ~D[2030-04-05]
        })

      attrs =
        league
        |> Map.from_struct()
        |> Map.take([
          :id,
          :name,
          :abbr,
          :current_date,
          :historical_year,
          :league_level,
          :league_state,
          :logo_filename,
          :season_year,
          :start_date
        ])

      assert attrs == %{
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
