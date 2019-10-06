defmodule OOTPUtility.Imports do
  @moduledoc """
  This module is the set of common operations that can be taken on an import, like reading the raw CSV
  data and prepping it to be imported.
  """
  @callback sanitize_csv_data(row :: list) :: list
  @callback sanitize_attributes(attributes :: map) :: map

  defmacro __using__(_) do
    quote do
      @behaviour OOTPUtility.Imports

      @attributes_to_import []

      def import_from_path(path), do: OOTPUtility.Imports.import_from_path(__MODULE__, path)

      @impl OOTPUtility.Imports
      def sanitize_attributes(attrs),
        do: OOTPUtility.Imports.sanitize_attributes(__MODULE__, attrs)

      @impl OOTPUtility.Imports
      def sanitize_csv_data(attrs_row),
        do: OOTPUtility.Imports.sanitize_csv_data(__MODULE__, attrs_row)

      defoverridable sanitize_attributes: 1, sanitize_csv_data: 1

      import OOTPUtility.Imports, only: [imports: 1]
    end
  end

  defmacro imports([{:attributes, attributes}, {:from, path}]) do
    module = __CALLER__.module
    Module.put_attribute(module, :attributes_to_import, attributes)
    Module.put_attribute(module, :import_path, path)

    # Also put it back in so it is accessible at run-time
    quote do
      @attributes_to_import unquote(attributes)
      @import_path unquote(path)
    end
  end

  def import_all_from(dir_path) do
    for module <- Module.get_attribute(__MODULE__, :modules_to_import) do
      with path <- Path.join(dir_path, Module.get_attribute(module, :import_path)) do
        require IEx; IEx.pry
        import_from_path(module, path)
      end
    end
  end

  def sanitize_attributes(_module, attrs), do: Morphix.atomorphiform(attrs)
  def sanitize_csv_data(_module, attrs_row), do: attrs_row

  def import_from_path(module, path) do
    path
    |> prepare_csv_file_for_import()
    |> create_attribute_maps_from_csv_rows(
      module,
      &module.sanitize_csv_data/1,
      &build_attributes_for_import/2
    )
    |> write_attributes_to_database(module)
  end

  def build_attributes_for_import(module, attrs) do
    module
    |> import_changeset(do_sanitize_attributes(module, attrs))
    |> Ecto.Changeset.apply_changes()
    |> Map.take(Module.get_attribute(module, :attributes_to_import))
  end

  def do_sanitize_attributes(module, attrs) do
    attrs
    |> Morphix.atomorphiform()
    |> elem(1)
    |> module.sanitize_attributes()
  end

  def import_changeset(module, attrs) do
    %{__struct__: module}
    |> Ecto.Changeset.cast(attrs, Module.get_attribute(module, :attributes_to_import))
    |> Ecto.Changeset.validate_required(Module.get_attribute(module, :attributes_to_import))
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
         module,
         sanitize_csv_data,
         csv_to_changeset
       ) do
    attributes
    |> Stream.map(&sanitize_csv_data.(&1))
    |> Stream.map(&Enum.zip(headers, &1))
    |> Stream.map(&Enum.into(&1, %{}))
    |> Stream.map(&csv_to_changeset.(module, &1))
  end

  defp write_attributes_to_database(attribute_maps, schema) do
    attribute_maps
    |> Stream.chunk_every(10_000)
    |> Enum.map(&OOTPUtility.Repo.insert_all(schema, &1))
    |> Enum.reduce(0, fn {count, _}, total_count -> total_count + count end)
  end
end
