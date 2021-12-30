defmodule OOTPUtility.Statistics.Batting.Game do
  alias OOTPUtility.Statistics.Batting.Player
  alias OOTPUtility.Games.Game

  use Player.Schema, composite_key: [:game_id, :player_id]

  @derive {Inspect,
           only: [
             :id,
             :game,
             :player,
             :position,
             :at_bats,
             :hits,
             :home_runs,
             :runs_batted_in,
             :batting_average
           ]}

  player_batting_schema "players_game_batting_stats" do
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

    belongs_to :game, Game
  end
end
