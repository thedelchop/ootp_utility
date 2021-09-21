defmodule OOTPUtility.Teams.Team do
  @type t() :: %__MODULE__{}
  alias OOTPUtility.{Imports, Schema, Utilities, Standings}
  alias OOTPUtility.Leagues.{Conference, Division, League}
  alias OOTPUtility.Teams.Affiliation

  use Schema

  schema "teams" do
    field :abbr, :string
    field :level, :string
    field :logo_filename, :string
    field :name, :string

    belongs_to :league, League
    belongs_to :conference, Conference
    belongs_to :division, Division

    has_one :record, Standings.TeamRecord

    has_many :affiliations, Affiliation

    has_many :affiliates, through: [:affiliations, :affiliate]
    has_one :organization, through: [:affiliations, :team], foreign_key: :affilate_id
  end

  use Imports, from: "teams.csv"

  def update_import_changeset(changeset) do
    changeset
    |> put_division_id()
    |> put_conference_id()
  end

  def sanitize_attributes(attrs),
    do:
      Utilities.rename_keys(attrs, [
        {:sub_league_id, :conference_id},
        {:team_id, :id},
        {:logo_file_name, :logo_filename}
      ])

  def should_import_from_csv?(%{allstar_team: "0"} = _attrs), do: true
  def should_import_from_csv?(_attrs), do: false

  defp put_division_id(%Ecto.Changeset{changes: changes} = changeset) do
    with division_id <- Division.generate_foreign_key(changes) do
      change(changeset, %{division_id: division_id})
    end
  end

  defp put_conference_id(%Ecto.Changeset{changes: changes} = changeset) do
    with conference_id <- Conference.generate_foreign_key(changes) do
      change(changeset, %{conference_id: conference_id})
    end
  end
end
