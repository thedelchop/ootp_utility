defmodule OOTPUtility.Leagues.Division do
  @type t() :: %__MODULE__{}

  alias OOTPUtility.{Imports, Schema, Utilities}
  alias OOTPUtility.Leagues.{Conference, League}

  use Schema,
    composite_key: [:league_id, :conference_id, :id],
    foreign_key: [:league_id, :conference_id, :division_id]

  use Imports,
    attributes: [:id, :name, :league_id, :conference_id],
    from: "divisions.csv"

  schema "divisions" do
    field :name, :string
    belongs_to :league, League
    belongs_to :conference, Conference
  end

  def update_import_changeset(changeset) do
    changeset
    |> put_composite_key()
    |> put_conference_id()
  end

  def sanitize_attributes(attrs),
    do: Utilities.rename_keys(attrs, [{:sub_league_id, :conference_id}, {:division_id, :id}])

  defp put_conference_id(%Ecto.Changeset{changes: changes} = changeset) do
    with conference_id <- Conference.generate_foreign_key(changes) do
      change(changeset, %{conference_id: conference_id})
    end
  end
end