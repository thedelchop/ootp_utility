defmodule OOTPUtility.Imports.Standings.TeamRecord do
  alias OOTPUtility.{Standings, Imports}

  use OOTPUtility.Imports,
    from: "team_record.csv",
    headers: [
      {:gb, :games_behind},
      {:l, :losses},
      {:w, :wins},
      {:pct, :winning_percentage},
      {:g, :games},
      {:pos, :position}
    ],
    schema: Standings.TeamRecord

  def update_changeset(changeset),
    do: Standings.TeamRecord.put_composite_key(changeset)

  def validate_changeset(%Ecto.Changeset{changes: %{team_id: team_id}} = _) do
    Imports.Agent.in_cache?(:teams, team_id)
  end
end
