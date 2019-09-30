defmodule OOTPUtility.Team.Record do
  use OOTPUtility.Schema
  import OOTPUtility.Imports, only: [import_from_path: 3]

  alias OOTPUtility.Team

  @import_attributes [
    :id,
    :games,
    :wins,
    :losses,
    :position,
    :winning_percentage,
    :games_behind,
    :streak,
    :magic_number,
    :team_id
  ]

  schema "team_records" do
    field :games, :integer
    field :games_behind, :float
    field :losses, :integer
    field :magic_number, :integer
    field :position, :integer
    field :streak, :integer
    field :winning_percentage, :float
    field :wins, :integer
    field :game_date, :date

    belongs_to :team, Team
  end

  def import_from_path(path) do
    import_from_path(path, __MODULE__, &build_attributes_for_import/1)
  end

  def build_attributes_for_import(attrs) do
    %__MODULE__{}
    |> changeset(sanitize_attributes(attrs))
    |> apply_changes()
    |> Map.take(@import_attributes)
  end

  def sanitize_attributes(attrs) do
    with {:ok, atomized_attrs} <- Morphix.atomorphiform(attrs) do
      atomized_attrs
      |> Map.put(:id, Map.get(atomized_attrs, :team_id))
    end
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, @import_attributes)
    |> validate_required(@import_attributes)
  end
end
