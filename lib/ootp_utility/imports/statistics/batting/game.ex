defmodule OOTPUtility.Imports.Statistics.Batting.Game do
  alias OOTPUtility.Statistics.Batting
  import OOTPUtility.Utilities, only: [position_from_scoring_key: 1, league_level_from_id: 1]

  import OOTPUtility.Imports.Statistics, only: [round_statistic: 2]
  import OOTPUtility.Imports.Statistics.Batting, only: [add_missing_statistics: 1]

  use OOTPUtility.Imports.Statistics.Batting,
    from: "players_game_batting",
    headers: [
      {:wpa, :win_probability_added},
      {:level_id, :level}
    ],
    schema: Batting.Game

  def update_changeset(%Ecto.Changeset{} = changeset) do
    changeset
    |> Batting.Game.put_composite_key()
    |> add_missing_statistics()
    |> round_statistic(:win_probability_added)
  end

  def should_import?(%{league_id: "0"} = _attrs), do: false
  def should_import?(_attrs), do: true

  def sanitize_attributes(%{team_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | team_id: nil})
  end

  def sanitize_attributes(%{league_id: league_id, level: level_id, position: position} = attrs) do
    league_id = if String.to_integer(league_id) < 1, do: nil, else: league_id

    %{
      attrs
      | league_id: league_id,
        position: position_from_scoring_key(position),
        level: league_level_from_id(level_id)
    }
  end

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            team_id: team_id,
            game_id: game_id
          }
        } = _changeset
      ) do
    OOTPUtility.Imports.ImportAgent.in_cache?(:teams, team_id) &&
      OOTPUtility.Imports.ImportAgent.in_cache?(:games, game_id)
  end
end
