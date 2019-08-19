defmodule OOTPUtility.Imports do
  @moduledoc """
  This module is the set of common operations that can be taken on an import, like reading the raw CSV
  data and prepping it to be imported.
  """
  alias OOTPUtility.Repo

  @doc """
  Import the raw data from a file and insert it into the database using the specified function

  ## Examples

      iex> import_from_file('priv/data/cities.csv', convert_city_csv_to_record)

  """
  @spec import_from_file(Path.t(), module(), [String.t()], ([String.t()] -> %{})) :: {String.t(), integer}
  def import_from_file(path, schema_module, headers, csv_to_changeset) do
    {
      path,
      path
      |> File.stream!()
      |> Stream.map(&String.trim(&1))
      |> Stream.map(&HtmlSanitizeEx.strip_tags(&1))
      |> Stream.map(&String.replace(&1, ~r/\s+/, " "))
      |> Stream.map(&String.replace(&1, ~s("), ""))
      |> Stream.flat_map(&String.split(&1, "\n"))
      |> Stream.map(&String.split(&1, ","))
      |> Stream.filter(fn
        ^headers -> false
        [""] -> false
        [_first | _] -> true
      end)
      |> Stream.map(&csv_to_changeset.(&1))
      |> Stream.chunk_every(10_000)
      |> Enum.map(&Repo.insert_all(schema_module, &1))
      |> Enum.reduce(0, fn ({count, _}, total_count) ->  total_count + count end)
    }
  end
end
