defmodule OOTPUtility.Games.Score do
  alias OOTPUtility.Games.Game
  @derive {Inspect, only: [:id, :inning, :score, :team, :game]}

  use OOTPUtility.Schema,
    composite_key: [:game_id, :team, :inning]

  schema "games_scores" do
    field :inning, :integer
    field :score, :integer
    field :team, :integer

    belongs_to :game, Game
  end
end
