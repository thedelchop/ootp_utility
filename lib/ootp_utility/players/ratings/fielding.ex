defmodule OOTPUtility.Players.Ratings.Fielding do
  use OOTPUtility.Schema, composite_key: [:player_id]

  alias OOTPUtility.Players.Player

  schema "players_fielding_ratings" do
    field :infield_range, :integer
    field :infield_error, :integer
    field :infield_arm, :integer
    field :turn_double_play, :integer

    field :outfield_range, :integer
    field :outfield_error, :integer
    field :outfield_arm, :integer

    field :catcher_ability, :integer
    field :catcher_arm, :integer

    belongs_to :player, Player
  end
end
