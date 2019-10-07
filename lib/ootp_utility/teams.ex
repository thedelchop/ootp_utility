defmodule OOTPUtility.Teams do
  alias OOTPUtility.{Repo, Team}
  alias OOTPUtility.Leagues.Division

  import Ecto.Query, only: [from: 2]

  def list_teams(%Division{} = division) do
    Repo.all(from(t in Team, where: t.division_id == ^division.id))
  end

  def list_teams, do: Repo.all(Team)

  def find_record(%Team{} = team), do: Repo.get_by(Team.Record, [team_id: team.id])
end
