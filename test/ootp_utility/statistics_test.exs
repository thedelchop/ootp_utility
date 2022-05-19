defmodule OOTPUtility.StatisticsTest do
  use OOTPUtility.DataCase, async: true

  alias OOTPUtility.Statistics
  import OOTPUtility.Factory

  describe "game_logs_for/2" do
    test "it returns a list of Statistics.Batting.Game when given a position player" do
      player = insert(:player, position: "3B")

      expected_game_stats = insert(:game_batting_stats, player: player)

      [%Statistics.Batting.Game{} | _] = actual_game_stats = Statistics.game_logs_for(player)

      assert ids_for(actual_game_stats) == ids_for([expected_game_stats])
    end

    test "it returns a list of Statistics.Pitching.Game when given a pitcher" do
      player = insert(:player, position: "SP")

      expected_game_stats = insert(:game_pitching_stats, player: player)

      %Statistics.Pitching.Game{} = actual_game_stats = Statistics.game_logs_for(player)

      assert ids_for(actual_game_stats) == ids_for([expected_game_stats])
    end

    test "it returns no more than 10 records by default" do
      player = insert(:player, position: "3B")

      insert_list(11, :game_batting_stats, player: player)

      assert(
        player
        |> Statistics.game_logs_for()
        |> Enum.count() == 10
      )
    end

    test "it returns no more than :limit, if included in the options" do
      player = insert(:player, position: "3B")

      insert_list(4, :game_batting_stats, player: player)

      assert(
        player
        |> Statistics.game_logs_for(limit: 3)
        |> Enum.count() == 3
      )
    end

    test "it only returns records for Games that occurred on or before the current league date by default" do
      league = insert(:league, current_date: ~D[2022-05-01])
      player = insert(:player, position: "3B", league: league)

      earlier_game =
        insert(:game, home_team: player.team, date: ~D[2022-04-29]) |> complete_game()

      earlier_game_stats = insert(:game_batting_stats, player: player, game: earlier_game)

      current_day_game =
        insert(:game, home_team: player.team, date: ~D[2022-05-01]) |> complete_game()

      current_day_game_stats = insert(:game_batting_stats, player: player, game: current_day_game)

      _later_game = insert(:game, home_team: player.team, date: ~D[2022-05-03])

      assert ids_for(Statistics.game_logs_for(player)) ==
               ids_for([earlier_game_stats, current_day_game_stats])
    end

    test "it only returns records for Games that occurred on or before the date specified by :before, if included in the options" do
      player = insert(:player, position: "3B")

      earlier_game =
        insert(:game, home_team: player.team, date: ~D[2022-04-29]) |> complete_game()

      earlier_game_stats = insert(:game_batting_stats, player: player, game: earlier_game)

      later_game = insert(:game, home_team: player.team, date: ~D[2022-05-03])

      _later_game_stats = insert(:game_batting_stats, player: player, game: later_game)

      assert ids_for(Statistics.game_logs_for(player, before: ~D[2022-04-30])) ==
               ids_for([earlier_game_stats])
    end

    test "it only returns records for Games that occurred on or after the date specified by :after, if included in the options" do
      player = insert(:player, position: "3B")

      earlier_game =
        insert(:game, home_team: player.team, date: ~D[2022-04-29]) |> complete_game()

      _earlier_game_stats = insert(:game_batting_stats, player: player, game: earlier_game)

      later_game = insert(:game, home_team: player.team, date: ~D[2022-05-03])

      later_game_stats = insert(:game_batting_stats, player: player, game: later_game)

      assert ids_for(Statistics.game_logs_for(player, after: ~D[2022-05-02])) ==
               ids_for([later_game_stats])
    end
  end

  describe "team_ranking/3" do
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

      assert Statistics.team_ranking(leader, :home_runs) == {1, 5, 450}

      assert Statistics.team_ranking(last_place_team, :home_runs) == {5, 5, 150}
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

      assert Statistics.team_ranking(subject_team, :home_runs) == {4, 6, 250}
    end

    test "it sorts any prevention stats is ascending order" do
      league = insert(:league)

      insert(:team_pitching_stats,
        team: insert(:team, league: league),
        league: league,
        runs: 450
      )

      insert(:team_pitching_stats,
        team: fn -> insert(:team, league: league) end,
        league: league,
        runs: 350
      )

      subject_team = insert(:team, league: league)

      insert(:team_pitching_stats, team: subject_team, league: league, runs: 250)

      insert_pair(:team_pitching_stats,
        team: fn -> insert(:team, league: league) end,
        league: league,
        runs: Faker.random_between(200, 245)
      )

      assert Statistics.team_ranking(subject_team, :runs_allowed) == {3, 5, 250}
    end
  end
end
