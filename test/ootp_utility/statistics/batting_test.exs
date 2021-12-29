defmodule OOTPUtility.Statistics.BattingTest do
  use OOTPUtility.DataCase, async: true

  import OOTPUtility.Factory
  alias OOTPUtility.Statistics.Batting

  describe "for_player/2" do
    setup do
      league = insert(:league, season_year: 2023)
      team = insert(:team, league: league)
      player = insert(:player, team: team)

      {:ok, team: team, player: player}
    end

    test "for_player/2 returns the batting statistics for the specified player when a single player is specified",
         %{player: player} do
      player_current_batting_stats = insert(:player_batting_stats, player: player)

      player_last_year_batting_stats = insert(:player_batting_stats, player: player, year: 2022)

      assert Batting.for_player(player).id == player_current_batting_stats.id
      refute Batting.for_player(player).id == player_last_year_batting_stats.id
    end

    test "for_player/2 returns the batting statistics for all the specified players when multiple are specified",
         %{player: player, team: team} do
      player_one = insert(:player, team: team)

      player_current_batting_stats = insert(:player_batting_stats, player: player)

      _player_last_year_batting_stats = insert(:player_batting_stats, player: player, year: 2022)

      player_one_current_batting_stats = insert(:player_batting_stats, player: player_one)

      _player_one_last_year_batting_stats =
        insert(:player_batting_stats, player: player_one, year: 2022)

      assert ids_for(Batting.for_player([player, player_one])) ==
               ids_for([player_current_batting_stats, player_one_current_batting_stats])
    end

    test "for_player/2 filters the statistics by the player's current team, in the current league year with no split",
         %{team: team, player: player} do
      other_team = insert(:team)

      player_batting_stats_split_all =
        insert(:player_batting_stats, player: player, team: team, year: 2023, split: :all)

      # Wrong split
      _player_batting_stats_split_right =
        insert(:player_batting_stats, player: player, team: team, year: 2023, split: :right)

      # Wrong year
      _player_batting_stats_last_year =
        insert(:player_batting_stats, player: player, team: team, year: 2022)

      # Wrong team
      _player_other_team_batting_stats =
        insert(:player_batting_stats, player: player, team: other_team, year: 2023)

      assert Batting.for_player(player).id == player_batting_stats_split_all.id
    end

    test "for_player/2 overrides the default filters (player's current team, current league year, no split), if options are specified",
         %{team: team, player: player} do
      other_team = insert(:team)

      _player_batting_stats_split_all =
        insert(:player_batting_stats, player: player, team: team, year: 2023, split: :all)

      player_batting_stats_split_right =
        insert(:player_batting_stats, player: player, team: team, year: 2023, split: :right)

      player_batting_stats_last_year =
        insert(:player_batting_stats, player: player, team: team, year: 2022)

      player_other_team_batting_stats =
        insert(:player_batting_stats, player: player, team: other_team, year: 2023)

      assert Batting.for_player(player, split: :right).id == player_batting_stats_split_right.id
      assert Batting.for_player(player, year: 2022).id == player_batting_stats_last_year.id
      assert Batting.for_player(player, team: other_team).id == player_other_team_batting_stats.id
    end

    test "for_player/2 removes a filter, if option is specified with :any",
         %{team: team, player: player} do
      other_team = insert(:team)

      player_batting_stats_split_all =
        insert(:player_batting_stats, player: player, team: team, year: 2023, split: :all)

      player_batting_stats_split_right =
        insert(:player_batting_stats, player: player, team: team, year: 2023, split: :right)

      _player_batting_stats_last_year =
        insert(:player_batting_stats, player: player, team: team, year: 2022)

      _player_other_team_batting_stats =
        insert(:player_batting_stats, player: player, team: other_team, year: 2023)

      assert ids_for(Batting.for_player(player, split: :any)) ==
               ids_for([player_batting_stats_split_all, player_batting_stats_split_right])
    end

    test "for_player/2 returns nil if there are no statistics for the specified player in the specified year",
         %{player: player} do
      insert(:player_batting_stats, player: player, year: 2022)

      assert is_nil(Batting.for_player(player))
    end

    test "for_player/2 returns an empty array if there are no statistics for the specified players in the specified year",
         %{team: team, player: player} do
      player_one = insert(:player, team: team)

      insert(:player_batting_stats, player: player, year: 2022)
      insert(:player_batting_stats, player: player_one, year: 2022)

      assert(
        [player, player_one]
        |> Batting.for_player()
        |> Enum.empty?()
      )
    end
  end
end
