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

      def rename_headers(headers),
        do: Enum.map(headers, &Keyword.get(unquote(header_renames), &1, &1))
    end
  end

  def import_from_csv(module, path) do
    path
    |> prepare_csv_file_for_import()
    |> create_attribute_maps_from_csv_rows(
      &module.rename_headers/1,
      &module.sanitize_attributes/1,
      &module.should_import?/1
    )
  end

  def should_import?(_module, _attrs_row), do: true
  def sanitize_attributes(_module, attrs), do: attrs

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
         translate_headers,
         sanitize_attributes,
         should_import?
       ) do
    translated_headers =
      headers
      |> Enum.map(&String.to_atom/1)
      |> translate_headers.()

    attributes
    |> Stream.map(&Enum.zip(translated_headers, &1))
    |> Stream.map(&Enum.into(&1, %{}))
    |> Stream.map(&Morphix.atomorphiform!/1)
    |> Stream.map(&sanitize_attributes.(&1))
    |> Stream.filter(&should_import?.(&1))
  end
end
