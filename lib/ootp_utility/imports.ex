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
        full_path = Path.join(path, unquote(filename))

        OOTPUtility.Imports.import_from_path(__MODULE__, full_path)
      end
    end
  end

  def import_from_path(module, path) do
    IO.puts("Starting import of #{module} records")

    Benchmark.measure(
      fn ->
        path
        |> module.import_from_csv()
        |> module.import_from_attributes()
      end,
      module
    )
  end

  def import_all_from_path(path) do
    modules_to_import()
    |> Enum.each(fn
      module ->
        module.import_from_path(path)
    end)
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
