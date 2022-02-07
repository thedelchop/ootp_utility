defmodule OOTPUtility.Players.Ratings.Running do
  use OOTPUtility.Schema, composite_key: [:player_id]

  alias OOTPUtility.Players.Player

  schema "players_running_ratings" do
    field :speed, :integer
    field :stealing_ability, :integer
    field :baserunning_ability, :integer

    belongs_to :player, Player
  end
end
