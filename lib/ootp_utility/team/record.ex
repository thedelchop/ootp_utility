defmodule OOTPUtility.Team.Record do
  use OOTPUtility.Schema
  import OOTPUtility.Imports, only: [import_from_path: 3]

  alias OOTPUtility.Team

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

    timestamps()
  end

  def import_from_path(path) do
    import_from_path(path, __MODULE__, &import_changeset/1)
  end

  def import_changeset(attrs) do
    with scrubbed_attributes <-
           attrs |> Map.put(:id, Map.get(attrs, :team_id)) do
      %__MODULE__{}
      |> changeset(scrubbed_attributes)
      |> apply_changes()
    end
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [
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
    ])
    |> validate_required([
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
    ])
  end
end
