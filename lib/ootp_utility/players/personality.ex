defmodule OOTPUtility.Players.Personality do
  use OOTPUtility.Schema

  alias OOTPUtility.Players.Player

  @personality_ratings [
    # 0 - 59
    low: 1,
    # 60 - 139
    normal: 2,
    # 140 - 200
    high: 3
  ]

  @primary_key false
  schema "players_personalities" do
    field :greed, Ecto.Enum, values: @personality_ratings
    field :loyalty, Ecto.Enum, values: @personality_ratings
    field :desire_to_win, Ecto.Enum, values: @personality_ratings
    field :work_ethic, Ecto.Enum, values: @personality_ratings
    field :intelligence, Ecto.Enum, values: @personality_ratings
    field :leadership, Ecto.Enum, values: @personality_ratings

    belongs_to :player, Player
  end
end
