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

    quote do
      use OOTPUtility.Imports.CSV,
        from: unquote(filename),
        headers: unquote(headers)

      use OOTPUtility.Imports.Schema,
        schema: unquote(schema),
        slug: unquote(slug)

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

    # Find all of the files from the directory that match
    # the file pattern for the module, sort them.

    # Strip the headers from the first file and ? remove the
    # line from the stream?

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

  def decode_files([file | []]) do
    file
    |> File.stream!(read_ahead: 100_000)
    |> do_decode_file(true)
    |> Flow.from_enumerable(stages: Application.fetch_env!(:ootp_utility, :import_stages))
  end

  def decode_files([file_with_headers | rest_of_files]) do
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

  def do_decode_file(file_to_decode, headers) do
    file_to_decode
    |> CSV.decode!(
      headers: headers,
      strip_fields: true
    )
  end

  def import_all_from_path(path) do
    modules_to_import()
    |> Enum.each(fn
      module ->
        module.import_from_path(path)
    end)
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

        import_all_from_path_async(dirname)

        {:ok, contents}

      {:error, error} ->
        IO.puts("League zip files extraction failed")

        {:ok, error}
    end
  end

  def import_all_from_path_async(path) do
    [
      Imports.Leagues.League,
      Imports.Leagues.Conference,
      Imports.Leagues.Division
    ]
    |> Enum.each(& &1.import_from_path(path))

    team_import_task =
      Task.Supervisor.async(
        OOTPUtility.ImportTaskSupervisor,
        Imports.Teams.Team,
        :import_from_path,
        [path]
      )

    Task.await(team_import_task, :infinity)

    IO.puts("Finished importing team records")

    player_import_task =
      Task.Supervisor.async(
        OOTPUtility.ImportTaskSupervisor,
        Imports.Players.Player,
        :import_from_path,
        [path]
      )

    team_tasks =
      stream_imports(
        [
          Imports.Teams.Affiliation,
          Imports.Standings.TeamRecord,
          Imports.Statistics.Batting.Team,
          Imports.Statistics.Pitching.Team.Combined,
          Imports.Statistics.Pitching.Team.Starters,
          Imports.Statistics.Pitching.Team.Bullpen,
          Imports.Statistics.Fielding.Team
        ],
        path
      )

    Task.await(player_import_task, :infinity)

    IO.puts("Finished importing player records")

    game_import_task =
      Task.Supervisor.async(
        OOTPUtility.ImportTaskSupervisor,
        Imports.Games.Game,
        :import_from_path,
        [path]
      )

    player_tasks =
      stream_imports(
        [
          Imports.Players.Attributes.Batting,
          Imports.Players.Attributes.Pitching,
          Imports.Players.Attributes.Pitches,
          Imports.Players.Attributes.Fielding,
          Imports.Players.Attributes.Position,
          Imports.Players.Attributes.Running,
          Imports.Players.Morale,
          Imports.Players.Personality,
          Imports.Teams.Roster.Membership,
          Imports.Statistics.Batting.Player,
          Imports.Statistics.Pitching.Player,
          Imports.Statistics.Fielding.Player
        ],
        path
      )

    Task.await(game_import_task, :infinity)

    IO.puts("Finished importing game records")

    game_tasks =
      stream_imports(
        [
          Imports.Statistics.Batting.Game,
          Imports.Statistics.Pitching.Game,
          Imports.Games.Score
        ],
        path
      )

    Task.yield_many(team_tasks ++ player_tasks ++ game_tasks, :infinity)

    batting_attrs_import_task =
      Task.Supervisor.async(
        OOTPUtility.ImportTaskSupervisor,
        Imports.Players.Attributes.Misc.Batting,
        :import_from_path,
        [path]
      )

    Task.await(batting_attrs_import_task, :infinity)

    pitching_attrs_import_task =
      Task.Supervisor.async(
        OOTPUtility.ImportTaskSupervisor,
        Imports.Players.Attributes.Misc.Pitching,
        :import_from_path,
        [path]
      )

    Task.await(pitching_attrs_import_task, :infinity)

    player_attrs_import_task =
      Task.Supervisor.async(
        OOTPUtility.ImportTaskSupervisor,
        Imports.Players.Attributes,
        :import_from_path,
        [path]
      )

    Task.await(player_attrs_import_task, :infinity)

    IO.puts("Finished importing all files from #{path}")
  end

  defp stream_imports(modules, path) do
    modules
    |> Enum.map(fn
      module ->
        Task.Supervisor.async(OOTPUtility.ImportTaskSupervisor, module, :import_from_path, [path])
    end)
  end

  defp modules_to_import do
    [
      Imports.Leagues.League,
      Imports.Leagues.Conference,
      Imports.Leagues.Division,
      Imports.Teams.Team,
      Imports.Teams.Affiliation,
      Imports.Standings.TeamRecord,
      Imports.Players.Player,
      Imports.Games.Game,
      Imports.Games.Score,
      Imports.Statistics.Batting.Team,
      Imports.Statistics.Batting.Player,
      Imports.Statistics.Batting.Game,
      Imports.Statistics.Pitching.Team.Combined,
      Imports.Statistics.Pitching.Team.Starters,
      Imports.Statistics.Pitching.Team.Bullpen,
      Imports.Statistics.Pitching.Player,
      Imports.Statistics.Pitching.Game,
      Imports.Statistics.Fielding.Team,
      Imports.Statistics.Fielding.Player
    ]
  end
end
