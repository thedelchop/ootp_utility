defmodule OOTPUtility.Players.Morale do
  use OOTPUtility.Schema, composite_key: [:player_id]

  alias OOTPUtility.Players.Player

  @morale_values [
    angry: 1,
    very_unhappy: 2,
    unhappy: 3,
    normal: 4,
    good: 5,
    very_good: 6,
    great: 7
  ]

  schema "players_morale" do
    field :personal_performance, Ecto.Enum, values: @morale_values
    field :role_on_team, Ecto.Enum, values: @morale_values
    field :team_performance, Ecto.Enum, values: @morale_values
    field :team_transactions, Ecto.Enum, values: @morale_values

    field :expectation, Ecto.Enum,
      values: [
        none: 1,
        starting_lineup: 2,
        starting_rotation: 3,
        bullpen: 4,
        closer: 5,
        bench_player: 6,
        top_of_lineup: 7,
        middle_of_lineup: 8,
        playing_in_majors: 9
      ]

    belongs_to :player, Player
  end
end
