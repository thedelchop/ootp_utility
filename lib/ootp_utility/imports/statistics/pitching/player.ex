defmodule OOTPUtility.Imports.Statistics.Pitching.Player do
  alias OOTPUtility.Statistics.Pitching

  import OOTPUtility.Imports.Statistics.Pitching, only: [add_missing_statistics: 1]
  import OOTPUtility.Imports.Statistics, only: [round_statistic: 2]
  import OOTPUtility.Utilities, only: [split_from_id: 1, league_level_from_id: 1]

  use OOTPUtility.Imports.Statistics.Pitching,
    from: "players_career_pitching_stats",
    headers: [
      {:ir, :inherited_runners},
      {:irs, :inherited_runners_scored},
      {:level_id, :level},
      {:li, :leverage_index},
      {:war, :wins_above_replacement},
      {:wpa, :win_probability_added},
      {:outs, :outs_pitched},
      {:split_id, :split}
    ],
    schema: Pitching.Player

  def update_changeset(%Ecto.Changeset{} = changeset) do
    changeset
    |> Pitching.Player.put_composite_key()
    |> add_missing_statistics()
    |> round_statistic(:wins_above_replacement)
    |> round_statistic(:win_probability_added)
    |> round_statistic(:leverage_index)
  end

  def sanitize_attributes(%{team_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | team_id: nil})
  end

  def sanitize_attributes(%{league_id: league_id, split: split_id, level: level_id} = attrs) do
    league_id = if String.to_integer(league_id) < 1, do: nil, else: league_id

    %{
      attrs
      | league_id: league_id,
        split: split_from_id(split_id),
        level: league_level_from_id(level_id)
    }
  end

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            team_id: team_id,
            player_id: player_id
          }
        } = _changeset
      ) do
    OOTPUtility.Imports.ImportAgent.in_cache?(:teams, team_id) &&
      OOTPUtility.Imports.ImportAgent.in_cache?(:players, player_id)
  end

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            team_id: team_id
          }
        } = _changeset
      ) do
    OOTPUtility.Imports.ImportAgent.in_cache?(:teams, team_id)
  end

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            player_id: player_id
          }
        } = _changeset
      ) do
    OOTPUtility.Imports.ImportAgent.in_cache?(:players, player_id)
  end

  def validate_changeset(_changeset), do: true
end
