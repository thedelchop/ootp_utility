defmodule OOTPUtility.Imports.Standings.TeamRecord do
  alias OOTPUtility.{Repo, Standings, Teams}
  import Ecto.Query, only: [from: 2]

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

  def validate_changeset(%Ecto.Changeset{changes: %{team_id: team_id}} = _changeset) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end
end
