defmodule OOTPUtility.Statistics.Fielding.Team do
  alias OOTPUtility.{Repo,Teams}
  alias OOTPUtility.Statistics.Fielding

  import Ecto.Query, only: [from: 2]

  use Fielding.Schema,
    from: "team_fielding_stats_stats.csv",
    composite_key: [:team_id, :year],
    foreign_key: [:team_id, :year]

  fielding_schema "team_fielding_stats" do
    field :catcher_earned_run_average, :float
  end

  def valid_for_import?(%{league_id: "0"} = _attrs), do: false

  def valid_for_import?(%{team_id: team_id} = _attrs) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end
end
