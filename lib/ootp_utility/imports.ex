defmodule OOTPUtility.Imports do
  @moduledoc """
  This module is the set of common operations that can be taken on an import, like reading the raw CSV
  data and prepping it to be imported.
  """
  alias OOTPUtility.Repo

  def import_from_path(path, schema, csv_to_changeset) do
    import_from_path(path, schema, fn csv_row -> csv_row end, csv_to_changeset)
  end

  def import_from_path(path, schema, sanitize_csv_data, csv_to_changeset) do
    path
    |> prepare_csv_file_for_import()
    |> create_attribute_maps_from_csv_rows(sanitize_csv_data, csv_to_changeset)
    |> write_attributes_to_database(schema)
  end

  defp prepare_csv_file_for_import(path) do
    path
    |> File.stream!()
    |> Stream.flat_map(&String.split(&1, "\n"))
    |> Stream.map(&HtmlSanitizeEx.strip_tags(&1))
    |> Stream.map(&String.replace(&1, ~r/\s+/, " "))
    |> Stream.map(&String.replace(&1, ~s("), ""))
    |> Stream.map(&String.split(&1, ","))
    |> Enum.filter(fn
      [""] -> false
      _ -> true
    end)
  end

  defp create_attribute_maps_from_csv_rows(
         [headers | attributes],
         sanitize_csv_data,
         csv_to_changeset
       ) do
    with sanitized_csv_data <- attributes |> Stream.map(&sanitize_csv_data.(&1)) do
      create_attribute_maps_from_csv_rows([headers | sanitized_csv_data], csv_to_changeset)
    end
  end

  defp create_attribute_maps_from_csv_rows([headers | attributes], csv_to_attribute_map) do
    attributes
    |> Stream.map(&Enum.zip(headers, &1))
    |> Stream.map(&Enum.into(&1, %{}))
    |> Stream.map(&csv_to_attribute_map.(&1))
  end

  defp write_attributes_to_database(attribute_maps, schema) do
    attribute_maps
    |> Stream.chunk_every(10_000)
    |> Enum.map(&Repo.insert_all(schema, &1))
    |> Enum.reduce(0, fn {count, _}, total_count -> total_count + count end)
  end
end
