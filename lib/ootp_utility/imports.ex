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

    quote do
      use OOTPUtility.Imports.CSV,
        from: unquote(filename),
        headers: unquote(headers)

      use OOTPUtility.Imports.Schema,
        schema: unquote(schema)

      def import_from_path(path) do
        with full_path <- Path.join(path, unquote(filename)) do
          import_from_csv(__MODULE__, full_path)
          |> import_from_attributes()
        end
      end
    end
  end

  def import_all_from_path(path) do
    modules_to_import()
    |> Enum.each(& &1.import_from_path(path))
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
