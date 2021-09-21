defmodule OOTPUtility.Teams.Affiliation do
  @type t() :: %__MODULE__{}
  alias OOTPUtility.{Imports, Repo, Schema, Utilities}
  alias OOTPUtility.Teams.Team

  import Ecto.Query, only: [from: 2]

  use Schema

  schema "team_affiliations" do
    belongs_to :team, Team
    belongs_to :affiliate, Team
  end

  use Imports, from: "team_affiliations.csv"

  def sanitize_attributes(attrs),
    do: Utilities.rename_keys(attrs, [{:affiliated_team_id, :affiliate_id}])

  def valid_for_import?(%{team_id: team_id, affiliate_id: affiliate_id} = _attrs) do
    Repo.exists?(from t in Team, where: t.id == ^team_id)
    Repo.exists?(from t in Team, where: t.id == ^affiliate_id)
  end

  def update_import_changeset(changeset) do
    changeset
    |> put_id()
  end

  defp put_id(
         %Ecto.Changeset{changes: %{team_id: team_id, affiliate_id: affiliate_id}} = changeset
       ),
       do: change(changeset, %{id: Enum.join([team_id, affiliate_id], "-")})
end
