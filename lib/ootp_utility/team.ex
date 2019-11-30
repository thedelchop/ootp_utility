defmodule OOTPUtility.Team do
  use OOTPUtility.Schema

  use OOTPUtility.Imports,
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

  alias OOTPUtility.{League, Utilities}
  alias OOTPUtility.Leagues.{Conference, Division}

  schema "teams" do
    field :abbr, :string
    field :level, :string
    field :logo_filename, :string
    field :name, :string

    belongs_to :league, League
    belongs_to :conference, Conference
    belongs_to :division, Division
  end

  @impl OOTPUtility.Imports
  def update_import_changeset(changeset) do
    changeset
    |> put_division_id()
    |> put_conference_id()
  end

  @impl OOTPUtility.Imports
  def sanitize_attributes(attrs),
    do: Utilities.rename_keys(attrs, [{:sub_league_id, :conference_id}, {:team_id, :id}])

  defp put_division_id(%Ecto.Changeset{changes: changes} = changeset) do
    with division_id <- Division.generate_composite_key(changes) do
      change(changeset, %{division_id: division_id})
    end
  end

  defp put_conference_id(%Ecto.Changeset{changes: changes} = changeset) do
    with conference_id <- Conference.generate_composite_key(changes) do
      change(changeset, %{conference_id: conference_id})
    end
  end
end
