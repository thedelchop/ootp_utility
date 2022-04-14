defmodule OOTPUtility.Imports do
  alias __MODULE__

  @moduledoc """
  This module is the set of common operations that can be taken on an import, like reading the raw CSV
  data and prepping it to be imported.
  """
  defmacro __using__(opts) do
    filename = Keyword.get(opts, :from)
    schema = Keyword.get(opts, :schema)
    headers = Keyword.get(opts, :headers, [])
    slug = Keyword.get(opts, :slug)
    cache = Keyword.get(opts, :cache, false)

    quote do
      use OOTPUtility.Imports.CSV,
        from: unquote(filename),
        headers: unquote(headers)

      use OOTPUtility.Imports.Schema,
        schema: unquote(schema),
        slug: unquote(slug),
        cache: unquote(cache)

      def import_from_path(path) do
        wildcard_path = [path, unquote(filename), "{_[1-50].csv,.csv}"] |> Enum.join()

        files =
          wildcard_path
          |> Path.wildcard()
          |> Enum.sort()

        OOTPUtility.Imports.import_from_path(__MODULE__, files)
      end

      def get_filename(), do: unquote(filename)
    end
  end

  def import_from_path(module, files) do
    IO.puts("Starting import of #{module} records")

    Benchmark.measure(
      fn ->
        files
        |> decode_files()
        |> module.import_from_csv()
        |> module.import_from_attributes()
      end,
      module
    )
  end

  def import_all_from_path(path) do
    Benchmark.measure(
      fn ->
        {:ok, session} = Imports.ImportSession.start_link(path)

        Imports.ImportSession.process_available_imports(session)
      end,
      "Complete import"
    )
  end

  def import_from_archive(zip_file_path) do
    dest = to_charlist(Application.fetch_env!(:ootp_utility, :uploads_directory))

    unzipped_content =
      zip_file_path
      |> String.to_charlist()
      |> :zip.unzip([{:cwd, dest}])

    case unzipped_content do
      {:ok, [file | _] = contents} ->
        IO.puts("League zip files extracted successfully")

        dirname = Path.dirname(file) <> "/"

        import_all_from_path(dirname)

        {:ok, contents}

      {:error, error} ->
        IO.puts("League zip files extraction failed")

        {:ok, error}
    end
  end

  defp decode_files([file | []]) do
    file
    |> File.stream!(read_ahead: 100_000)
    |> do_decode_file(true)
    |> Flow.from_enumerable(stages: Application.fetch_env!(:ootp_utility, :import_stages))
  end

  defp decode_files([file_with_headers | rest_of_files]) do
    [headers] =
      file_with_headers
      |> File.stream!()
      |> CSV.decode!(headers: false, strip_fields: true)
      |> Enum.take(1)

    file_with_headers_stream =
      file_with_headers
      |> File.stream!(read_ahead: 100_000)
      |> do_decode_file(true)

    rest_of_file_streams =
      rest_of_files
      |> Enum.map(&File.stream!(&1, read_ahead: 100_000))
      |> Enum.flat_map(&Stream.chunk_every(&1, 10_000))
      |> Enum.map(&do_decode_file(&1, headers))

    Flow.from_enumerables([file_with_headers_stream] ++ rest_of_file_streams,
      stages: Application.fetch_env!(:ootp_utility, :import_stages)
    )
  end

  defp do_decode_file(file_to_decode, headers) do
    file_to_decode
    |> CSV.decode!(
      headers: headers,
      strip_fields: true
    )
  end
end
