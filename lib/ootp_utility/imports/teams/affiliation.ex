defmodule OOTPUtility.Imports.Teams.Affiliation do
  use OOTPUtility.Imports,
    from: "team_affiliations",
    headers: [{:affiliated_team_id, :affiliate_id}],
    schema: OOTPUtility.Teams.Affiliation

  def update_changeset(changeset),
    do: OOTPUtility.Teams.Affiliation.put_composite_key(changeset)

  def validate_changeset(
        %Ecto.Changeset{changes: %{team_id: team_id, affiliate_id: affiliate_id}} = _c
      ) do
    OOTPUtility.Imports.Agent.in_cache?(:teams, team_id) &&
      OOTPUtility.Imports.Agent.in_cache?(:teams, affiliate_id)
  end
end
