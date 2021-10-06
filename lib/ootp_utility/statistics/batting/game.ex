defmodule OOTPUtility.Statistics.Batting.Game do
  alias OOTPUtility.Statistics.Batting.Player
  alias OOTPUtility.Games.Game

  use Player.Schema, composite_key: [:game_id, :player_id]

  player_batting_schema "players_game_batting_stats" do
    field :position, :integer

    belongs_to :game, Game
  end
end
