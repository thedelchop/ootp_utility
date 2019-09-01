defmodule OOTPUtility.Imports do
  @moduledoc """
  This module is the set of common operations that can be taken on an import, like reading the raw CSV
  data and prepping it to be imported.
  """
  alias OOTPUtility.Repo

  def read_from_path(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&HtmlSanitizeEx.strip_tags(&1))
    |> Stream.map(&String.replace(&1, ~r/\s+/, " "))
    |> Stream.map(&String.replace(&1, ~s("), ""))
    |> Stream.flat_map(&String.split(&1, "\n"))
    |> Stream.map(&String.split(&1, ","))
  end

  def trim_headers(attribute_values, headers) do
    attribute_values
    |> Stream.filter(fn
      ^headers -> false
      _ -> true
    end)
  end

  def build_attributes_map(attr_values, attr_names, transform_function) do
    attr_values
    |> Stream.map(&transform_function.(&1))
    |> Stream.map(&Enum.zip(attr_names, &1))
    |> Stream.map(&Enum.into(&1, %{}))
  end

  def insert_into_database(changesets, schema_module) do
    changesets
    |> Stream.chunk_every(10_000)
    |> Enum.map(&Repo.insert_all(schema_module, &1))
    |> Enum.reduce(0, fn {count, _}, total_count -> total_count + count end)
  end
end
