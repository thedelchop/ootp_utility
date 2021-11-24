defmodule OOTPUtility.StandingsTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Standings
  import OOTPUtility.Factory

  describe "team_records" do
    setup do
      {:ok, team_record: insert(:team_record)}
    end

    test "get_team_record!/1 returns the team_record with given id", %{team_record: team_record} do
      assert Standings.get_team_record!(team_record.id).id == team_record.id
    end
  end
end
