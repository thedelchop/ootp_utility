defmodule OOTPUtility.Statistics.Fielding.Player do
  alias OOTPUtility.Players
  alias OOTPUtility.Statistics.Fielding

  @derive {Inspect,
           only: [
             :id,
             :player,
             :team,
             :year,
             :games,
             :outs_played,
             :put_outs,
             :assists,
             :errors,
             :fielding_percentage
           ]}

  use Fielding.Schema,
    composite_key: [:year, :player_id, :team_id, :position]

  fielding_schema "players_career_fielding_stats" do
    field :zone_rating, :float
    field :reached_on_error, :integer

    field :position, Ecto.Enum,
      values: [
        pitcher: 1,
        catcher: 2,
        first_base: 3,
        second_base: 4,
        third_base: 5,
        shortstop: 6,
        left_field: 7,
        center_field: 8,
        right_field: 9,
        designated_: 10,
        starting_pitcher: 11,
        middle_reliever: 12,
        closer: 13
      ]

    belongs_to :player, Players.Player
  end
end
