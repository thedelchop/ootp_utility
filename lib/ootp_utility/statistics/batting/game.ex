defmodule OOTPUtility.Statistics.Batting.Game do
  alias OOTPUtility.Statistics.Batting.Player
  alias OOTPUtility.Games.Game

  use Player.Schema, composite_key: [:game_id, :player_id]

  @derive {Inspect,
           only: [
             :id,
             :game,
             :player,
             :position,
             :at_bats,
             :hits,
             :home_runs,
             :runs_batted_in,
             :batting_average
           ]}

  player_batting_schema "players_game_batting_stats" do
    field :position, :integer

    belongs_to :game, Game
  end
end
