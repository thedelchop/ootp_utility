defmodule OOTPUtility.Statistics.Batting.Team do
  alias OOTPUtility.Statistics.Batting

  use Batting.Schema,
    composite_key: [:team_id, :year]

  batting_schema "team_batting_stats" do
    field :weighted_on_base_average, :float
    field :runs_created_per_27_outs, :float
  end
end
