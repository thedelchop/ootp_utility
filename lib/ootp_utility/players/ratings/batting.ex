defmodule OOTPUtility.Players.Ratings.Batting do
  use OOTPUtility.Schema, composite_key: [:player_id, :type]

  alias OOTPUtility.Players.Player

  schema "players_batting_ratings" do
    field :type, Ecto.Enum,
      values: [ability: 1, ability_vs_left: 2, ability_vs_right: 3, talent: 4]

    field :contact, :integer
    field :gap_power, :integer
    field :home_run_power, :integer
    field :eye, :integer
    field :avoid_strikeouts, :integer

    field :bunt, :integer
    field :bunt_for_hit, :integer
    field :groundball_hitter_type, :integer
    field :flyball_hitter_type, :integer

    belongs_to :player, Player
  end
end
