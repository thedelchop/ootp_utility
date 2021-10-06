defmodule OOTPUtility.Statistics.Pitching.Game do
  alias OOTPUtility.Statistics.Pitching.Player
  alias OOTPUtility.Games

  use Player.Schema,
    composite_key: [:game_id, :player_id]

  player_pitching_schema "players_game_pitching_stats" do
    belongs_to :game, Games.Game
  end
end
