defmodule OOTPUtility.Utilities do
  @moduledoc """
  This module contains some pretty generic helper methods for development, like, lookups for translating positions on
  the field, like LF, into their scoring representation (9), or words like "first", "second", and "3rd" into their respective
  bases (first -> 1B)
  """

  @spec position_from_scoring_key(String.t() | integer()) :: {:ok, String.t()} | :error
  def position_from_scoring_key(scoring_key) when is_integer(scoring_key) do
    scoring_key
    |> Integer.to_string()
    |> position_from_scoring_key()
  end

  def position_from_scoring_key(scoring_key) do
    Map.fetch(
      %{
        "1" => "P",
        "2" => "C",
        "3" => "1B",
        "4" => "2B",
        "5" => "3B",
        "6" => "SS",
        "7" => "LF",
        "8" => "CF",
        "9" => "RF",
        "10" => "DH",
        "11" => "SP",
        "12" => "MR",
        "13" => "CL"
      },
      scoring_key
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
