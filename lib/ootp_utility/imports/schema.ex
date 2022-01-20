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

  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)
    slug_fields = [Keyword.get(opts, :slug)]

    slug_fields =
      slug_fields
      |> List.flatten()
      |> Enum.reject(&is_nil/1)

    if is_nil(schema) do
      raise OOTPUtility.Imports.CSV.MissingSourceFilename, __MODULE__
    end

    quote do
      @spec validate_changeset(Ecto.Changeset.t()) :: boolean()
      def validate_changeset(%Ecto.Changeset{} = changeset),
        do: OOTPUtility.Imports.Schema.validate_changeset(__MODULE__, changeset)

      @spec update_changeset(Ecto.Changeset.t()) :: Ecto.Changeset.t()
      def update_changeset(%Ecto.Changeset{} = changeset),
        do: OOTPUtility.Imports.Schema.update_changeset(__MODULE__, changeset)

      def write_records_to_database(attrs),
        do:
          OOTPUtility.Imports.Schema.write_records_to_database(__MODULE__, attrs, unquote(schema))

      defoverridable update_changeset: 1,
                     validate_changeset: 1,
                     write_records_to_database: 1

      def import_from_attributes(attributes),
        do:
          OOTPUtility.Imports.Schema.import_from_attributes(
            __MODULE__,
            unquote(schema),
            attributes
          )

      if Enum.empty?(unquote(slug_fields)) do
        def put_slug(%Ecto.Changeset{} = changeset), do: changeset
      else
        def put_slug(%Ecto.Changeset{} = changeset) do
          slug_source =
            unquote(slug_fields)
            |> Enum.map(&Ecto.Changeset.get_field(changeset, &1))
            |> Enum.join(" ")

          slug = Slug.slugify(slug_source)

          Ecto.Changeset.change(changeset, %{slug: slug})
        end
      end
    end
  end

  def validate_changeset(_module, changeset), do: changeset
  def update_changeset(_module, changeset), do: changeset

  def import_from_attributes(module, schema, attributes) do
    attributes_to_import = schema.__schema__(:fields)

    window = Flow.Window.count(500)

    attributes
    |> Flow.map(&List.wrap/1)
    |> Flow.flat_map(& &1)
    |> Flow.map(&import_changeset(module, schema, &1, attributes_to_import))
    |> Flow.filter(&module.validate_changeset/1)
    |> Flow.map(&Ecto.Changeset.apply_changes/1)
    |> Flow.map(&Map.from_struct/1)
    |> Flow.map(&Map.take(&1, attributes_to_import))
    |> Flow.partition(window: window, stages: 1)
    |> Flow.reduce(fn -> [] end, &[&1 | &2])
    |> Flow.on_trigger(fn attributes ->
      {ids, _} = module.write_records_to_database(attributes)

      write_imported_records_to_cache(ids, schema)

      {ids, attributes}
    end)
    |> Flow.run()
  end

  def import_changeset(module, schema, attrs, attributes_to_import) do
    schema.__struct__
    |> Ecto.Changeset.cast(attrs, attributes_to_import)
    |> module.update_changeset()
    |> module.put_slug()
  end

  def write_records_to_database(_module, attrs, schema) do
    {_, records} = OOTPUtility.Repo.insert_all(schema, attrs, returning: [:id])

    {Enum.map(records, & &1.id), attrs}
  end

  defp write_imported_records_to_cache([], _schema), do: :ok

  defp write_imported_records_to_cache(new_record_ids, schema) do
    schema
    |> table_name()
    |> OOTPUtility.Imports.Agent.put_cache(new_record_ids)
  end

  defp table_name(schema) do
    :source |> schema.__schema__() |> String.to_atom()
  end
end
