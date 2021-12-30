defmodule OOTPUtility.Imports.Statistics.Batting.Player do
  alias OOTPUtility.Statistics.Batting

  import OOTPUtility.Imports.Statistics, only: [round_statistic: 2]
  import OOTPUtility.Imports.Statistics.Batting, only: [add_missing_statistics: 1]

  import OOTPUtility.Utilities, only: [league_level_from_id: 1, split_from_id: 1]

  use OOTPUtility.Imports.Statistics.Batting,
    from: "players_career_batting_stats",
    headers: [
      {:war, :wins_above_replacement},
      {:wpa, :win_probability_added},
      {:level_id, :level},
      {:split_id, :split}
    ],
    schema: Batting.Player

  def update_changeset(%Ecto.Changeset{} = changeset) do
    changeset
    |> Batting.Player.put_composite_key()
    |> add_missing_statistics()
    |> round_statistic(:wins_above_replacement)
    |> round_statistic(:win_probability_added)
  end

  def should_import?(%{league_id: "0"} = _attrs), do: false
  def should_import?(_attrs), do: true

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
        } = _
      ) do
    OOTPUtility.Imports.Agent.in_cache?(:teams, team_id) &&
      OOTPUtility.Imports.Agent.in_cache?(:players, player_id)
  end

  def validate_changeset(_changeset), do: true
end
