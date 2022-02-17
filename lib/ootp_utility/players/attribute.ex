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

  @batting_attrs [
    "contact",
    "gap_power",
    "home_run_power",
    "eye",
    "avoid_strikeouts"
  ]

  defguard is_batting_attribute(attr) when attr in @batting_attrs
  def batting_attributes, do: as_atoms(@batting_attrs)

  @pitching_attrs ["stuff", "movement", "control"]

  defguard is_pitching_attribute(attr) when attr in @pitching_attrs
  def pitching_attributes, do: as_atoms(@pitching_attrs)

  @fielding_attrs [
    "infield_range",
    "infield_error",
    "infield_arm",
    "turn_double_play",
    "outfield_range",
    "outfield_error",
    "outfield_arm",
    "catcher_arm",
    "catcher_ability"
  ]

  defguard is_fielding_attribute(attr) when attr in @fielding_attrs
  def fielding_attributes, do: as_atoms(@fielding_attrs)

  @pitches [
    "fastballl",
    "slider",
    "curveball",
    "screwball",
    "forkball",
    "changeup",
    "sinker",
    "splitter",
    "knuckleball",
    "cutter",
    "circle_change",
    "knuckle_curve"
  ]
  defguard is_pitch(attr) when attr in @pitches
  def pitches, do: as_atoms(@pitches)

  @baserunning_attrs ["speed", "stealing", "baserunning"]
  defguard is_baserunning_attribute(attr) when attr in @baserunning_attrs
  def baserunning_attributes, do: as_atoms(@baserunning_attrs)

  @bunting_attrs ["sacrifice_bunt", "bunt_for_hit"]
  defguard is_bunting_attribute(attr) when attr in @bunting_attrs
  def bunting_attributes, do: as_atoms(@bunting_attrs)

  @positions Ecto.Enum.values(Player, :position) |> Enum.map(&Atom.to_string/1)
  defguard is_position(attr) when attr in @positions
  def positions, do: as_atoms(@positions)

  defp as_atoms(attributes) do
    attributes |> Enum.map(&String.to_atom/1)
  end
end
