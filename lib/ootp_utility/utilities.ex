defmodule OOTPUtility.Utilities do
  @moduledoc """
  This module contains some pretty generic helper methods for development, like, lookups for translating positions on
  the field, like LF, into their scoring representation (9), or words like "first", "second", and "3rd" into their respective 
  bases (first -> 1B)
  """

  @doc """
  Convert position abbreviation in their scoring key

  ## Examples
    iex> OOTPUtility.Utilities.scoring_key_from_position("3B") #-> 5
  """
  @spec scoring_key_from_position(String.t()) :: {:ok, String.t()} | :error
  def scoring_key_from_position(position) do
    scoring_key =
      %{
        "P" => "1",
        "C" => "2",
        "1B" => "3",
        "2B" => "4",
        "3B" => "5",
        "SS" => "6",
        "LF" => "7",
        "CF" => "8",
        "RF" => "9"
      }[position]

    if is_nil(scoring_key), do: :error, else: {:ok, scoring_key}
  end

  @spec position_from_scoring_key(String.t()) :: {:ok, String.t()} | :error
  def position_from_scoring_key(scoring_key) do
    position =
      %{
        1 => "P",
        2 => "C",
        3 => "1B",
        4 => "2B",
        5 => "3B",
        6 => "SS",
        7 => "LF",
        8 => "CF",
        9 => "RF"
      }[String.to_integer(scoring_key)]

    if is_nil(position), do: :error, else: {:ok, position}
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
end
