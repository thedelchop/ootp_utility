defmodule OOTPUtility.Imports.Statistics.Batting.Team do
  alias OOTPUtility.Statistics.Batting
  import OOTPUtility.Imports.Statistics, only: [round_statistic: 2]
  import OOTPUtility.Imports.Helpers, only: [convert_league_level: 1]

  use OOTPUtility.Imports.Statistics.Batting,
    from: "team_batting_stats",
    headers: [
      {:avg, :batting_average},
      {:ebh, :extra_base_hits},
      {:iso, :isolated_power},
      {:level_id, :level},
      {:obp, :on_base_percentage},
      {:ops, :on_base_plus_slugging},
      {:rc, :runs_created},
      {:rc27, :runs_created_per_27_outs},
      {:s, :singles},
      {:sbp, :stolen_base_percentage},
      {:slg, :slugging},
      {:tb, :total_bases},
      {:woba, :weighted_on_base_average}
    ],
    schema: Batting.Team

  def sanitize_attributes(%{level: league_level} = attrs) do
    %{attrs | level: convert_league_level(league_level)}
  end

  def update_changeset(changeset) do
    changeset
    |> Batting.Team.put_composite_key()
    |> round_statistic(:batting_average)
    |> round_statistic(:isolated_power)
    |> round_statistic(:on_base_percentage)
    |> round_statistic(:on_base_plus_slugging)
    |> round_statistic(:runs_created)
    |> round_statistic(:runs_created_per_27_outs)
    |> round_statistic(:stolen_base_percentage)
    |> round_statistic(:slugging)
    |> round_statistic(:weighted_on_base_average)
  end

  def should_import?(%{league_id: "0"} = _attrs), do: false
  def should_import?(_attrs), do: true

  def validate_changeset(%Ecto.Changeset{changes: %{team_id: team_id}} = _) do
    OOTPUtility.Imports.Agent.in_cache?(:teams, team_id)
  end
end
