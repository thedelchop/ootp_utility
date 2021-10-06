defmodule OOTPUtility.Statistics.Fielding.Player do
  alias OOTPUtility.Players
  alias OOTPUtility.Statistics.Fielding

  use Fielding.Schema,
    composite_key: [:player_id, :team_id, :year, :position]

  fielding_schema "players_career_fielding_stats" do
    field :zone_rating, :float
    field :reached_on_error, :integer
    field :position, :integer

    belongs_to :player, Players.Player
  end
end
