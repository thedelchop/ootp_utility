defmodule OOTPUtility.Statistics.BattingTest do
  use OOTPUtility.DataCase

  alias OOTPUtility.Statistics.Batting
  import OOTPUtility.Factory

  describe "ranking/2" do
    test "it returns a tuple representing the teams ranking in their league" do
      league = insert(:league)

      leader = insert(:team, league: league)
      insert(:team_batting_stats, team: leader, league: league, home_runs: 450)

      last_place_team = insert(:team, league: league)
      insert(:team_batting_stats, team: last_place_team, league: league, home_runs: 150)

      insert_list(3, :team_batting_stats,
        team: fn -> insert(:team, league: league) end,
        league: league,
        home_runs: Faker.random_between(200, 400)
      )

      assert Batting.ranking(leader, :home_runs, :league) == {1, 5, 450}

      assert Batting.ranking(last_place_team, :home_runs, :league) == {5, 5, 150}
    end

    test "it correctly handles rankings when there are ties" do
      league = insert(:league)

      insert(:team_batting_stats,
        team: insert(:team, league: league),
        league: league,
        home_runs: 450
      )

      insert_pair(:team_batting_stats,
        team: fn -> insert(:team, league: league) end,
        league: league,
        home_runs: 350
      )

      subject_team = insert(:team, league: league)

      insert(:team_batting_stats, team: subject_team, league: league, home_runs: 250)

      insert_pair(:team_batting_stats,
        team: fn -> insert(:team, league: league) end,
        league: league,
        home_runs: Faker.random_between(200, 245)
      )

      assert Batting.ranking(subject_team, :home_runs, :league) == {4, 6, 250}
    end
  end
end
