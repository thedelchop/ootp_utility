defmodule OOTPUtility.Imports.Teams.Roster.Membership do
  alias OOTPUtility.{Imports, Teams}

  use Imports,
    from: "team_roster",
    headers: [{:list_id, :type}],
    schema: Teams.Roster.Membership

  def sanitize_attributes(%{type: "1"} = attrs) do
    sanitize_attributes(%{attrs | type: "preseason"})
  end

  def sanitize_attributes(%{type: "2"} = attrs) do
    sanitize_attributes(%{attrs | type: "active"})
  end

  def sanitize_attributes(%{type: "3"} = attrs) do
    sanitize_attributes(%{attrs | type: "expanded"})
  end

  def sanitize_attributes(%{type: "4"} = attrs) do
    sanitize_attributes(%{attrs | type: "injured"})
  end

  def sanitize_attributes(attrs), do: attrs

  def update_changeset(changeset),
    do: Teams.Roster.Membership.put_composite_key(changeset)

  def validate_changeset(%Ecto.Changeset{changes: %{team_id: team_id, player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:teams, team_id) &&
      Imports.Agent.in_cache?(:players, player_id)
  end
end
