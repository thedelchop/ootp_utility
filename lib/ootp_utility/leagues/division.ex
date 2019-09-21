defmodule OOTPUtility.Leagues.Division do
  use OOTPUtility.Schema, composite_key: [:league_id, :conference_id, :division_id]
  import OOTPUtility.Imports, only: [import_from_path: 3]

  alias OOTPUtility.{League, Team}
  alias OOTPUtility.Leagues.Conference

  schema "divisions" do
    field :name, :string
    belongs_to :league, League
    belongs_to :conference, Conference
    has_many :teams, Team
  end

  def import_from_path(path) do
    import_from_path(path, __MODULE__, &import_changeset/1)
  end

  def import_changeset(attrs) do
    with scrubbed_attributes <-
           attrs |> Map.put(:id, generate_composite_key(attrs)) |> Map.delete(:division_id) do
      %__MODULE__{}
      |> changeset(scrubbed_attributes)
      |> apply_changes()
    end
  end

  @doc false
  def changeset(division, attrs) do
    division
    |> cast(attrs, [:id, :name, :league_id, :conference_id])
    |> validate_required([:id, :name, :league_id, :conference_id])
  end
end
