defmodule OOTPUtility.Imports do
  @moduledoc """
  This module is the set of common operations that can be taken on an import, like reading the raw CSV
  data and prepping it to be imported.
  """
  @callback sanitize_csv_data(row :: list) :: list
  @callback sanitize_attributes(attributes :: map) :: map

  defmacro __using__([{:attributes, attributes}, {:from, path}]) do
    quote do
      @behaviour unquote(__MODULE__)

      @import_path unquote(path)

      @impl OOTPUtility.Imports
      def sanitize_attributes(attrs),
        do: OOTPUtility.Imports.sanitize_attributes(__MODULE__, attrs)

      @impl OOTPUtility.Imports
      def sanitize_csv_data(attrs_row),
        do: OOTPUtility.Imports.sanitize_csv_data(__MODULE__, attrs_row)

      defoverridable sanitize_attributes: 1, sanitize_csv_data: 1

      def build_attributes_for_import(attrs) do
        OOTPUtility.Imports.build_attributes_for_import(__MODULE__, attrs, unquote(attributes))
      end

      def import_from_path(path), do: OOTPUtility.Imports.import_from_path(__MODULE__, path)
    end
  end

  def import_changeset(module, attrs, attributes_to_import) do
    %{__struct__: module}
    |> Ecto.Changeset.cast(attrs, attributes_to_import)
    |> Ecto.Changeset.validate_required(attributes_to_import)
  end

  def build_attributes_for_import(module, attrs, attributes_to_import) do
    module
    |> import_changeset(do_sanitize_attributes(module, attrs), attributes_to_import)
    |> Ecto.Changeset.apply_changes()
    |> Map.take(attributes_to_import)
  end

  def do_sanitize_attributes(module, attrs) do
    attrs
    |> Morphix.atomorphiform()
    |> elem(1)
    |> module.sanitize_attributes()
  end

  def import_all_from(dir_path) do
    for module <- implementors() do
      module.import_from_path(dir_path)
    end
  end

  defp implementors() do
    for({module, _} <- :code.all_loaded(), do: module)
    |> Enum.filter(&implemented_by?/1)
  end

  defp implemented_by?(module) do
    module.module_info[:attributes]
    |> Keyword.get(:behaviour, [])
    |> Enum.member?(__MODULE__)
  end

  def sanitize_attributes(_module, attrs), do: Morphix.atomorphiform(attrs)
  def sanitize_csv_data(_module, attrs_row), do: attrs_row

  def import_from_path(module, path) do
    path
    |> prepare_csv_file_for_import()
    |> create_attribute_maps_from_csv_rows(
      &module.sanitize_csv_data/1,
      &module.build_attributes_for_import/1
    )
    |> write_attributes_to_database(module)
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
    attributes
    |> Stream.map(&sanitize_csv_data.(&1))
    |> Stream.map(&Enum.zip(headers, &1))
    |> Stream.map(&Enum.into(&1, %{}))
    |> Stream.map(&csv_to_changeset.(&1))
  end

  defp write_attributes_to_database(attribute_maps, schema) do
    attribute_maps
    |> Stream.chunk_every(10_000)
    |> Enum.map(&OOTPUtility.Repo.insert_all(schema, &1))
    |> Enum.reduce(0, fn {count, _}, total_count -> total_count + count end)
  end
end
