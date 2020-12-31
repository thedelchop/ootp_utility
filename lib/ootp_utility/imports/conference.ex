defmodule OOTPUtility.Imports.Conference do
  @type t() :: %__MODULE__{}

  use OOTPUtility.Schema,
    composite_key: [:league_id, :id],
    foreign_key: [:league_id, :conference_id]

  use OOTPUtility.Imports,
    attributes: [:id, :name, :abbr, :designated_hitter, :league_id],
    from: "sub_leagues.csv"

  alias OOTPUtility.Utilities

  schema "conferences" do
    field :name, :string
    field :abbr, :string
    field :designated_hitter, :boolean, default: false

    field :league_id, :string
  end

  def update_import_changeset(changeset), do: put_composite_key(changeset)

  def sanitize_attributes(attrs),
    do: Utilities.rename_keys(attrs, [{:sub_league_id, :id}])
end
