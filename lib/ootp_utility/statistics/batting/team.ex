defmodule OOTPUtility.Statistics.Batting.Team do
  alias OOTPUtility.Statistics.Batting

  @derive {Inspect,
           only: [
             :id,
             :team,
             :year,
             :runs,
             :home_runs,
             :stolen_bases,
             :batting_average,
             :on_base_plus_slugging
           ]}

  use Batting.Schema,
    composite_key: [:team_id, :year]

  batting_schema "team_batting_stats" do
    field :weighted_on_base_average, :float
    field :runs_created_per_27_outs, :float
  end
end
