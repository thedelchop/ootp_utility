defmodule OOTPUtility.Statistics.Fielding.Team do
  alias OOTPUtility.Statistics.Fielding

  @derive {Inspect,
           only: [
             :id,
             :team,
             :year,
             :games,
             :outs_played,
             :put_outs,
             :assists,
             :errors,
             :fielding_percentage
           ]}

  use Fielding.Schema,
    composite_key: [:team_id, :year]

  fielding_schema "team_fielding_stats" do
    field :catcher_earned_run_average, :float
  end
end
