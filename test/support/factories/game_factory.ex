defmodule OOTPUtility.GameFactory do
  alias OOTPUtility.Games.Game

  defmacro __using__(_opts) do
    quote do
      def game_factory do
        %Game{
          id: sequence(:id, &"#{&1}"),
          attendance: 25_000,
          date: ~D[2021-09-22],
          dh: true,
          type: :season,
          played: false,
          time: ~T[14:00:00],
          league: fn -> build(:league) end,
          home_team: fn game -> build(:team, league: game.league) end,
          away_team: fn game -> build(:team, league: game.league) end
        }
      end

      def completed(%Game{played: true} = game), do: game

      def completed_game_factory do
        struct!(
          game_factory(),
          %{
            away_team_errors: Enum.random(0..3),
            away_team_hits: Enum.random(0..10),
            away_team_runs: Enum.random(0..5),
            home_team_errors: Enum.random(0..3),
            home_team_hits: Enum.random(0..10),
            home_team_runs: Enum.random(0..5),
            innings: 9,
            played: true,
            winning_pitcher: fn game -> build(:player, team: game.home_team) end,
            losing_pitcher: fn game -> build(:player, team: game.away_team) end,
            away_team_starter: fn game -> build(:player, team: game.away_team) end,
            home_team_starter: fn game -> build(:player, team: game.home_team) end,
            save_pitcher: fn game -> build(:player, team: game.home_team) end
          }
        )
      end
    end
  end
end
