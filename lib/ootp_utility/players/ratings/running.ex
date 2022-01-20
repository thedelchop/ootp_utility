defmodule OOTPUtility.Players.Ratings.Running do
  use OOTPUtility.Schema

  alias OOTPUtility.Players.Player

  @primary_key false
  schema "players_running_ratings" do
    field :speed, :integer
    field :stealing_ability, :integer
    field :baserunning_ability, :integer

    belongs_to :player, Player
  end
end
