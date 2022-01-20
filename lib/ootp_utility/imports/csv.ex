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

      @spec sanitize_attributes(map()) :: map() | [map()]
      def sanitize_attributes(attrs),
        do: OOTPUtility.Imports.CSV.sanitize_attributes(__MODULE__, attrs)

      defoverridable sanitize_attributes: 1,
                     should_import?: 1

      def import_from_csv(attribute_as_csv_stream),
        do: OOTPUtility.Imports.CSV.import_from_csv(__MODULE__, attribute_as_csv_stream)

      def rename_headers(attributes) do
        Enum.into(attributes, %{}, fn
          {k, v} ->
            header = Keyword.get(unquote(header_renames), k, k)
            {header, v}
        end)
      end
    end
  end

  def import_from_csv(module, attribute_stream) do
    attribute_stream
    |> Flow.map(&Morphix.atomorphiform!/1)
    |> Flow.map(&module.rename_headers/1)
    |> Flow.filter(&module.should_import?/1)
    |> Flow.map(&module.sanitize_attributes/1)
  end

  def should_import?(_module, _attrs_row), do: true
  def sanitize_attributes(_module, attrs), do: attrs
end
