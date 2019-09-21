defmodule OOTPUtility.Leagues.Conference do
  use OOTPUtility.Schema, composite_key: [:league_id, :conference_id]
  import OOTPUtility.Imports, only: [import_from_path: 3]

  alias OOTPUtility.{League, Team}
  alias OOTPUtility.Leagues.Division

  schema "conferences" do
    field :name, :string
    field :abbr, :string
    field :designated_hitter, :boolean, default: false

    belongs_to :league, League

    has_many :divisions, Division
    has_many :teams, Team
  end

  def import_from_path(path) do
    import_from_path(path, __MODULE__, &import_changeset/1)
  end

  def import_changeset(attrs) do
    with attrs_with_conference_id <-
           attrs |> Map.put(:conference_id, attrs[:sub_league_id]),
         scrubbed_attributes <-
           attrs_with_conference_id
           |> Map.put(:id, generate_composite_key(attrs_with_conference_id))
           |> Map.delete(:conference_id)
           |> Map.delete(:sub_league_id) do
      %__MODULE__{}
      |> changeset(scrubbed_attributes)
      |> apply_changes()
    end
  end

  @doc false
  def changeset(conference, attrs) do
    conference
    |> cast(attrs, [:id, :name, :abbr, :designated_hitter, :league_id])
    |> validate_required([:id, :name, :abbr, :designated_hitter, :league_id])
  end
end
