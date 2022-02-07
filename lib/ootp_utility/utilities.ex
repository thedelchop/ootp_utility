defmodule OOTPUtility.Utilities do
  @moduledoc """
  This module contains some pretty generic helper methods for development, like, lookups for translating positions on
  the field, like LF, into their scoring representation (9), or words like "first", "second", and "3rd" into their respective
  bases (first -> 1B)
  """

  def position_name_to_position_key() do
    %{
      pitcher: "P",
      catcher: "C",
      first_base: "1B",
      second_base: "2B",
      third_base: "3B",
      shortstop: "SS",
      left_field: "LF",
      center_field: "CF",
      right_field: "RF",
      designated_hitter: "DH",
      starting_pitcher: "SP",
      middle_reliever: "MR",
      closer: "CL"
    }
  end

  def position_key_to_position_name() do
    position_name_to_position_key()
    |> Map.to_list()
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Enum.into(%{})
  end

  def position_names(), do: Map.keys(position_name_to_position_key())
  def position_keys(), do: Map.values(position_name_to_position_key())

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
    Map.fetch!(position_key_to_position_name(), position_key)
  end

  @spec get_position_key(atom()) :: String.t()
  def get_position_key(position) do
    Map.fetch!(position_name_to_position_key(), position)
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

  @spec convert_outs_to_innings(integer()) :: float()
  def convert_outs_to_innings(number_of_outs) do
    whole_innings = div(number_of_outs, 3) / 1

    case rem(number_of_outs, 3) do
      0 ->
        whole_innings

      1 ->
        whole_innings + 0.3

      2 ->
        whole_innings + 0.6
    end
  end

end
