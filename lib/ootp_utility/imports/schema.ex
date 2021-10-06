defmodule OOTPUtility.Imports.Schema do
  defmodule MissingSchema do
    alias __MODULE__

    defexception [:message]

    @impl true
    def exception(module) do
      msg = "#{module} is using OOTPUtility.Imports.Schema, but no :schema was specified"

      %MissingSchema{message: msg}
    end
  end

  defmacro __using__([{:schema, schema}]) do
    if(is_nil(schema)) do
      raise OOTPUtility.Imports.CSV.MissingSourceFilename, __MODULE__
    end

    quote do
      @spec validate_changeset(Ecto.Changeset.t()) :: Ecto.Changeset.t()
      def validate_changeset(%Ecto.Changeset{} = changeset),
        do: OOTPUtility.Imports.Schema.validate_changeset(__MODULE__, changeset)

      @spec update_changeset(Ecto.Changeset.t()) :: Ecto.Changeset.t()
      def update_changeset(%Ecto.Changeset{} = changeset),
        do: OOTPUtility.Imports.Schema.update_changeset(__MODULE__, changeset)

      defoverridable update_changeset: 1,
                     validate_changeset: 1

      def import_from_attributes(attributes),
        do:
          OOTPUtility.Imports.Schema.import_from_attributes(
            __MODULE__,
            unquote(schema),
            attributes
          )
    end
  end

  def validate_changeset(_module, changeset), do: changeset
  def update_changeset(_module, changeset), do: changeset

  def import_from_attributes(module, schema, attributes) do
    attributes_to_import = schema.__schema__(:fields)

    attributes
    |> Stream.map(&import_changeset(module, schema, &1, attributes_to_import))
    |> Stream.filter(&module.validate_changeset/1)
    |> Stream.map(&Ecto.Changeset.apply_changes/1)
    |> Stream.map(&Map.from_struct/1)
    |> Stream.map(&Map.take(&1, attributes_to_import))
    |> write_attributes_to_database(schema)
  end

  def import_changeset(module, schema, attrs, attributes_to_import) do
    schema.__struct__
    |> Ecto.Changeset.cast(attrs, attributes_to_import)
    |> module.update_changeset()
    |> Ecto.Changeset.validate_required(attributes_to_import)
  end

  defp write_attributes_to_database(attribute_maps, schema) do
    attribute_maps
    |> Stream.chunk_every(500)
    |> Enum.map(&OOTPUtility.Repo.insert_all(schema, &1))
    |> Enum.reduce(0, fn {count, _}, total_count -> total_count + count end)
  end
end
