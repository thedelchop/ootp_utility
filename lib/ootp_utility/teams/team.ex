defmodule OOTPUtility.Teams.Team do
  @type t() :: %__MODULE__{}
  alias OOTPUtility.{Imports, Schema, Utilities}
  alias OOTPUtility.Leagues.{Conference, Division, League}

  use Schema

  use Imports,
    attributes: [
      :id,
      :abbr,
      :name,
      :logo_filename,
      :level,
      :league_id,
      :conference_id,
      :division_id
    ],
    from: "teams.csv"

  schema "teams" do
    field :abbr, :string
    field :level, :string
    field :logo_filename, :string
    field :name, :string

    belongs_to :league, League
    belongs_to :conference, Conference
    belongs_to :division, Division
  end

  def update_import_changeset(changeset) do
    changeset
    |> put_division_id()
    |> put_conference_id()
  end

  def sanitize_attributes(attrs),
    do: Utilities.rename_keys(attrs, [{:sub_league_id, :conference_id}, {:team_id, :id}])

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