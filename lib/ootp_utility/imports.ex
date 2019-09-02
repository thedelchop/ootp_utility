defmodule OOTPUtility.Imports do
  @moduledoc """
  This module is the set of common operations that can be taken on an import, like reading the raw CSV
  data and prepping it to be imported.
  """
  alias OOTPUtility.Repo
  alias Ecto.Multi

  def import_from_path(path, csv_to_changeset) do
    path
    |> prepare_csv_file_for_import()
    |> create_attribute_maps_from_csv_rows(csv_to_changeset)
    |> write_attributes_to_database()
  end

  def import_from_path(path, sanitize_attributes, csv_to_changeset) do
    path
    |> prepare_csv_file_for_import()
    |> create_attribute_maps_from_csv_rows(sanitize_attributes, csv_to_changeset)
    |> write_attributes_to_database()
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

  defp create_attribute_maps_from_csv_rows([headers | attributes], sanitize_attributes, csv_to_changeset) do
    attributes
    |> Stream.map(&sanitize_attributes.(&1))
    |> Stream.map(&Enum.zip(headers, &1))
    |> Stream.map(&Enum.into(&1, %{}))
    |> Stream.map(&csv_to_changeset.(&1))
  end

  defp create_attribute_maps_from_csv_rows([headers | attributes], csv_to_changeset ) do
    attributes
    |> Stream.map(&Enum.zip(headers, &1))
    |> Stream.map(&Enum.into(&1, %{}))
    |> Stream.map(&csv_to_changeset.(&1))
  end

  defp write_attributes_to_database(attribute_maps) do
    attribute_maps
    |> Stream.chunk_every(10_000)
    |> Enum.reduce(0, fn
      attributes, total_count ->
        attributes
        |> Enum.reduce(Multi.new(), &Multi.insert(&2, "insert_record_#{Ecto.UUID.generate()}", &1)) 
        |> Repo.transaction()

        total_count + Enum.count(attributes)
    end)
  end
end
