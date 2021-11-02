defmodule OOTPUtility.Imports.CSV do
  defmodule MissingSourceFilename do
    alias __MODULE__

    defexception [:message]

    @impl true
    def exception(module) do
      msg =
        "#{module} is using OOTPUtility.Imports.CSV, but no filename was specified with `:from`"

      %MissingSourceFilename{message: msg}
    end
  end

  defmacro __using__(opts) do
    filename = Keyword.get(opts, :from)

    if is_nil(filename) do
      raise OOTPUtility.Imports.CSV.MissingSourceFilename, __MODULE__
    end

    header_renames = Keyword.get(opts, :headers, [])

    quote do
      import OOTPUtility.Imports.CSV

      @spec should_import?(map()) :: boolean
      def should_import?(attrs_row),
        do: OOTPUtility.Imports.CSV.should_import?(__MODULE__, attrs_row)

      @spec sanitize_attributes(map()) :: map()
      def sanitize_attributes(attrs),
        do: OOTPUtility.Imports.CSV.sanitize_attributes(__MODULE__, attrs)

      defoverridable sanitize_attributes: 1,
                     should_import?: 1

      def import_from_csv(path),
        do: OOTPUtility.Imports.CSV.import_from_csv(__MODULE__, path)

      def rename_headers(attributes) do
        Enum.into(attributes, %{}, fn
          {k, v} ->
            header = Keyword.get(unquote(header_renames), k, k)
            {header, v}
        end)
      end
    end
  end

  def import_from_csv(module, path) do
    path
    |> File.stream!()
    |> prepare_csv_file_for_import()
    |> CSV.decode!(
      headers: true,
      strip_fields: true,
      workers: System.schedulers_online()
    )
    |> create_attribute_maps_from_csv_rows(
      &module.rename_headers/1,
      &module.sanitize_attributes/1,
      &module.should_import?/1
    )
  end

  def should_import?(_module, _attrs_row), do: true
  def sanitize_attributes(_module, attrs), do: attrs

  defp prepare_csv_file_for_import(csv_file_as_stream) do
    csv_file_as_stream
    |> Stream.map(&sanitize_row/1)
    |> Stream.filter(fn
      "" -> false
      _ -> true
    end)
  end

  defp sanitize_row(row) do
    row
    |> String.replace(~r/\s+/, " ")
    |> String.replace(~s("), "")
  end

  defp create_attribute_maps_from_csv_rows(
         attributes,
         translate_headers,
         sanitize_attributes,
         should_import?
       ) do
    attributes
    |> Flow.from_enumerable(stages: System.schedulers_online())
    |> Flow.map(&Morphix.atomorphiform!/1)
    |> Flow.map(&translate_headers.(&1))
    |> Flow.map(&sanitize_attributes.(&1))
    |> Flow.filter(&should_import?.(&1))
  end
end
