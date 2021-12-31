defmodule OOTPUtility.Utilities do
  @moduledoc """
  This module contains some pretty generic helper methods for development, like, lookups for translating positions on
  the field, like LF, into their scoring representation (9), or words like "first", "second", and "3rd" into their respective
  bases (first -> 1B)
  """

  @spec position_from_scoring_key(String.t() | integer()) :: atom()
  def position_from_scoring_key(scoring_key) when is_integer(scoring_key) do
    scoring_key
    |> Integer.to_string()
    |> position_from_scoring_key()
  end

  def position_from_scoring_key(scoring_key) do
    Map.fetch!(
      %{
        "0" => :pinch_hitter,
        "1" => :pitcher,
        "2" => :catcher,
        "3" => :first_base,
        "4" => :second_base,
        "5" => :third_base,
        "6" => :shortstop,
        "7" => :left_field,
        "8" => :center_field,
        "9" => :right_field,
        "10" => :designated_hitter,
        "11" => :starting_pitcher,
        "12" => :middle_reliever,
        "13" => :closer
      },
      scoring_key
    )
  end

  @spec expand_position_key(String.t()) :: atom()
  def expand_position_key(position_key) do
    Map.fetch!(
      %{
        "P" => :pitcher,
        "C" => :catcher,
        "1B" => :first_base,
        "2B" => :second_base,
        "3B" => :third_base,
        "SS" => :shortstop,
        "LF" => :left_field,
        "CF" => :center_field,
        "RF" => :right_field,
        "DH" => :designated_hitter,
        "SP" => :starting_pitcher,
        "MR" => :middle_reliever,
        "CL" => :closer
      },
      position_key
    )
  end

  @spec get_position_key(atom()) :: String.t()
  def get_position_key(position) do
    Map.fetch!(
      %{
       pitcher:           "P",
       catcher:           "C",
       first_base:        "1B",
       second_base:       "2B",
       third_base:        "3B",
       shortstop:         "SS",
       left_field:        "LF",
       center_field:      "CF",
       right_field:       "RF",
       designated_hitter: "DH",
       starting_pitcher:  "SP",
       middle_reliever:   "MR",
       closer:             "CL"
      },
      position
    )
  end

  @spec split_from_id(String.t() | integer()) :: atom()
  def split_from_id(split_id) when is_integer(split_id) do
    split_id
    |> Integer.to_string()
    |> split_from_id()
  end

  def split_from_id(split_id) do
    Map.fetch!(
      %{
        "1" => :all,
        "2" => :left,
        "3" => :right,
        "19" => :preseason,
        "21" => :postseason
      },
      split_id
    )
  end

  @spec league_level_from_id(String.t() | integer()) :: atom()
  def league_level_from_id(level_id) when is_integer(level_id) do
    level_id
    |> Integer.to_string()
    |> league_level_from_id()
  end

  def league_level_from_id(level_id) do
    Map.fetch!(
      %{
        "1" => :major,
        "2" => :triple_a,
        "3" => :double_a,
        "4" => :single_a,
        "5" => :low_a,
        "6" => :rookie,
        "8" => :international,
        "10" => :college,
        "11" => :high_school
      },
      level_id
    )
  end

  @spec position_from_base(String.t()) :: {:ok, String.t()} | :error
  def position_from_base(base) do
    position =
      %{
        "first" => "1B",
        "1st" => "1B",
        "second" => "2B",
        "2nd" => "2B",
        "third" => "3B",
        "3rd" => "3B",
        "home" => "Home"
      }[String.downcase(base)]

    if is_nil(position), do: :error, else: {:ok, position}
  end

  @spec rename_keys(list(), list(tuple())) :: map()
  def rename_keys(keys, []), do: keys

  def rename_keys(keys, renames) do
    keys
    |> Enum.map(fn
      key ->
        Keyword.get(renames, key, key)
    end)
  end
end
