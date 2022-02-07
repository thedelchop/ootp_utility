defmodule OOTPUtility.Players.Ratings.Pitches do
  use OOTPUtility.Schema, composite_key: [:player_id, :type]

  alias OOTPUtility.Players.Player

  schema "players_pitch_ratings" do
    field :type, Ecto.Enum, values: [ability: 1, talent: 4]

    field :fastballl, :integer
    field :slider, :integer
    field :curveball, :integer
    field :screwball, :integer
    field :forkball, :integer
    field :changeup, :integer
    field :sinker, :integer
    field :splitter, :integer
    field :knuckleball, :integer
    field :cutter, :integer
    field :circle_change, :integer
    field :knuckle_curve, :integer

    belongs_to :player, Player
  end
end
