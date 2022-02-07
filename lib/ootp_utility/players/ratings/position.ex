defmodule OOTPUtility.Players.Ratings.Position do
  use OOTPUtility.Schema, composite_key: [:player_id]

  alias OOTPUtility.Players.Player

  schema "players_position_ratings" do
    field :pitcher, :integer
    field :catcher, :integer
    field :first_base, :integer
    field :second_base, :integer
    field :third_base, :integer
    field :shortstop, :integer
    field :left_field, :integer
    field :center_field, :integer
    field :right_field, :integer

    belongs_to :player, Player
  end
end
