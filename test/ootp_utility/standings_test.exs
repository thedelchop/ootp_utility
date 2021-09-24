defmodule OOTPUtility.StandingsTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Standings
  import OOTPUtility.{StandingsFixtures, TeamsFixtures}

  describe "team_records" do
    setup do
      team_record = team_record_fixture(%{}, team_fixture())

      {:ok, team_record: team_record}
    end

    test "get_team_record!/1 returns the team_record with given id", %{team_record: team_record} do
      assert Standings.get_team_record!(team_record.id) == team_record
    end
  end
end
