defmodule OOTPUtility.StandingsTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Standings
  import OOTPUtility.{LeaguesFixtures, StandingsFixtures, TeamsFixtures}

  describe "team_records" do
    setup do
      team_record = 
        league_fixture()
        |> conference_fixture()
        |> division_fixture()
        |> team_fixture() 
        |> team_record_fixture()

      {:ok, team_record: team_record}
    end

    test "list_team_records/0 returns all team_records", %{team_record: team_record} do
      assert Standings.list_team_records() == [team_record]
    end

    test "get_team_record!/1 returns the team_record with given id", %{team_record: team_record} do
      assert Standings.get_team_record!(team_record.id) == team_record
    end
  end
end
