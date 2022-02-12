defmodule OOTPUtility.Players.Attribute do
  @moduledoc """
  A schema that represents one of several ratings that a player has associated with them.

  The schema is simple, only having three fields:

    name: The name of the attribute
    type: The type [:ability, :ability_vs_right, :ability_vs_left, :talent]
    value: An integer from 1-200 scale to represent the players talent or ability
  """

  use OOTPUtility.Schema

  alias OOTPUtility.Players.Player

  @primary_key false
  schema "player_attributes" do
    field :name, :string

    field :type, Ecto.Enum,
      values: [
        ability: 1,
        ability_vs_left: 2,
        ability_vs_right: 3,
        talent: 4
      ]

    field :value, :integer

    belongs_to :player, Player
  end

  def batting_attributes,
    do: [:contact, :gap_power, :home_run_power, :eye, :avoid_strikeouts]

  def pitching_attributes, do: [:stuff, :movement, :control]

  def fielding_attributes do
    [
      :infield_range,
      :infield_error,
      :infield_arm,
      :turn_double_play,
      :outfield_range,
      :outfield_error,
      :outfield_arm,
      :catcher_arm,
      :catcher_ability
    ]
  end

  def pitches do
    [
      :fastballl,
      :slider,
      :curveball,
      :screwball,
      :forkball,
      :changeup,
      :sinker,
      :splitter,
      :knuckleball,
      :cutter,
      :circle_change,
      :knuckle_curve
    ]
  end

  def baserunning_attributes, do: [:speed, :stealing, :baserunning]

  def bunting_attributes, do: [:sacrifice_bunt, :bunt_for_hit]

  def positions, do: Ecto.Enum.values(Player, :position)
end
