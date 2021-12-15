defmodule OOTPUtility.Statistics.PitchingTest do
  use OOTPUtility.DataCase

  import OOTPUtility.Factory
  alias OOTPUtility.Statistics.Pitching

  describe "for_player/2" do
    test "for_player/2 returns the pitching statistics for the specified player when a single player is specified" do
      league = insert(:league, season_year: 2023)
      player = insert(:player, league: league)

      player_current_pitching_stats =
        insert(:player_pitching_stats, player: player, league: league)

      player_last_year_pitching_stats =
        insert(:player_pitching_stats, player: player, league: league, year: 2022)

      assert Pitching.for_player(player, 2023).id == player_current_pitching_stats.id
      refute Pitching.for_player(player, 2023).id == player_last_year_pitching_stats.id
    end

    test "for_player/2 returns the pitching statistics for all the specified players when multiple are specified" do
      league = insert(:league, season_year: 2023)
      player_one = insert(:player, league: league)
      player_two = insert(:player, league: league)

      player_one_current_pitching_stats =
        insert(:player_pitching_stats, player: player_one, league: league)

      _player_one_last_year_pitching_stats =
        insert(:player_pitching_stats, player: player_one, league: league, year: 2022)

      player_two_current_pitching_stats =
        insert(:player_pitching_stats, player: player_two, league: league)

      _player_two_last_year_pitching_stats =
        insert(:player_pitching_stats, player: player_two, league: league, year: 2022)

      assert ids_for(Pitching.for_player([player_one, player_two], 2023)) ==
               ids_for([player_one_current_pitching_stats, player_two_current_pitching_stats])
    end

    test "for_player/2 returns nil if there are no statistics for the specified player in the specified year" do
      league = insert(:league, season_year: 2023)
      player = insert(:player, league: league)

      insert(:player_pitching_stats, player: player, league: league, year: 2022)

      assert is_nil(Pitching.for_player(player, 2023))
    end

    test "for_player/2 returns an empty array if there are no statistics for the specified players in the specified year" do
      league = insert(:league, season_year: 2023)
      player_one = insert(:player, league: league)
      player_two = insert(:player, league: league)

      insert(:player_pitching_stats, player: player_one, league: league, year: 2022)
      insert(:player_pitching_stats, player: player_two, league: league, year: 2022)

      assert(
        [player_one, player_two]
        |> Pitching.for_player(2023)
        |> Enum.empty?()
      )
    end
  end
end
