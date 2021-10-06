defmodule OOTPUtility.Imports.Teams.Affiliation do
  alias OOTPUtility.{Repo, Teams}

  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports,
    from: "team_affiliations.csv",
    headers: [{:affiliated_team_id, :affiliate_id}],
    schema: OOTPUtility.Teams.Affiliation

  def update_changeset(changeset),
    do: OOTPUtility.Teams.Affiliation.put_composite_key(changeset)

  def validate_changeset(
        %Ecto.Changeset{changes: %{team_id: team_id, affiliate_id: affiliate_id}} = _c
      ) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^affiliate_id) &&
      Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end
end
