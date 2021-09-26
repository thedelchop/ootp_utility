defmodule OOTPUtility.Imports do
  import Ecto.Changeset, only: [cast: 3, validate_required: 2, apply_changes: 1]

  @moduledoc """
  This module is the set of common operations that can be taken on an import, like reading the raw CSV
  data and prepping it to be imported.
  """

  defmacro __using__([{:from, filename}]) do
    quote do
      @spec sanitize_csv_data(map()) :: map()
      def sanitize_csv_data(attrs_row),
        do: OOTPUtility.Imports.sanitize_csv_data(__MODULE__, attrs_row)

      @spec should_import_from_csv?(map()) :: boolean
      def should_import_from_csv?(attrs_row),
        do: OOTPUtility.Imports.should_import_from_csv?(__MODULE__, attrs_row)

      @spec sanitize_attributes(map()) :: map()
      def sanitize_attributes(attrs),
        do: OOTPUtility.Imports.sanitize_attributes(__MODULE__, attrs)

      @spec valid_for_import?(Ecto.Changeset.t(__MODULE__.t())) :: boolean
      def valid_for_import?(changeset),
        do: OOTPUtility.Imports.valid_for_import?(__MODULE__, changeset)

      @spec update_import_changeset(Ecto.Changeset.t(__MODULE__.t())) :: Ecto.Changeset.t()
      def update_import_changeset(changeset) do
        OOTPUtility.Imports.update_import_changeset(__MODULE__, changeset)
      end

      defoverridable sanitize_attributes: 1,
                     sanitize_csv_data: 1,
                     update_import_changeset: 1,
                     should_import_from_csv?: 1,
                     valid_for_import?: 1

      @spec build_attributes_for_import(map()) :: map()
      def build_attributes_for_import(attrs) do
        OOTPUtility.Imports.build_attributes_for_import(
          __MODULE__,
          attrs,
          __MODULE__.__schema__(:fields)
        )
      end

      def import_from_path(path) do
        with full_path <- Path.join(path, unquote(filename)) do
          __MODULE__
          |> OOTPUtility.Imports.import_from_path(full_path)
        end
      end
    end
  end

  def update_import_changeset(__module__, changeset), do: changeset

  def import_changeset(module, attrs, attributes_to_import) do
    %{__struct__: module}
    |> cast(attrs, attributes_to_import)
    |> module.update_import_changeset()
    |> validate_required(attributes_to_import)
  end

  def build_attributes_for_import(module, attrs, attributes_to_import) do
    module
    |> import_changeset(module.sanitize_attributes(attrs), attributes_to_import)
    |> apply_changes()
    |> Map.take(attributes_to_import)
  end

  def import_all_from(dir_path, skipped_modules \\ []) do
    for module <- implementors() do
      unless Enum.member?(skipped_modules, module) do
        module.import_from_path(dir_path)
      end
    end
  end

  def implementors() do
    [
      OOTPUtility.Leagues.League,
      OOTPUtility.Leagues.Conference,
      OOTPUtility.Leagues.Division,
      OOTPUtility.Teams.Team,
      OOTPUtility.Teams.Affiliation,
      OOTPUtility.Standings.TeamRecord,
      OOTPUtility.Players.Player,
      OOTPUtility.Games.Game,
      OOTPUtility.Games.Score,
      OOTPUtility.Statistics.Fielding.Team,
      OOTPUtility.Statistics.Pitching.Team,
      OOTPUtility.Statistics.Pitching.Team.Starters,
      OOTPUtility.Statistics.Pitching.Team.Bullpen,
      OOTPUtility.Statistics.Batting.Player,
      OOTPUtility.Statistics.Batting.Game,
      OOTPUtility.Statistics.Batting.Team
    ]
  end

  def sanitize_csv_data(_module, attrs_row), do: attrs_row
  def should_import_from_csv?(_module, _attrs_row), do: true

  def sanitize_attributes(_module, attrs), do: attrs
  def valid_for_import?(_module, _changeset), do: true

  def import_from_path(module, path) do
    path
    |> prepare_csv_file_for_import()
    |> create_attribute_maps_from_csv_rows(
      &module.sanitize_csv_data/1,
      &module.should_import_from_csv?/1
    )
    |> import_from_attributes(module)
  end

  defp import_from_attributes(attributes, module) do
    attributes
    |> Stream.map(&module.build_attributes_for_import(&1))
    |> Stream.filter(&module.valid_for_import?(&1))
    |> write_attributes_to_database(module)
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
         sanitize_csv_data,
         should_import_from_csv?
       ) do
    attributes
    |> Stream.map(&sanitize_csv_data.(&1))
    |> Stream.map(&Enum.zip(headers, &1))
    |> Stream.map(&Enum.into(&1, %{}))
    |> Stream.map(&Morphix.atomorphiform!/1)
    |> Stream.filter(&should_import_from_csv?.(&1))
  end

  defp write_attributes_to_database(attribute_maps, schema) do
    attribute_maps
    |> Stream.chunk_every(1_000)
    |> Enum.map(&OOTPUtility.Repo.insert_all(schema, &1))
    |> Enum.reduce(0, fn {count, _}, total_count -> total_count + count end)
  end
end
