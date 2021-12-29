defmodule OOTPUtility.Imports.Statistics.Pitching.Game do
  alias OOTPUtility.Statistics.Pitching

  import OOTPUtility.Imports.Statistics.Pitching, only: [add_missing_statistics: 1]
  import OOTPUtility.Imports.Statistics, only: [round_statistic: 2]

  use OOTPUtility.Imports.Statistics.Pitching,
    from: "players_game_pitching_stats",
    headers: [
      {:ir, :inherited_runners},
      {:irs, :inherited_runners_scored},
      {:li, :leverage_index},
      {:wpa, :win_probability_added},
      {:outs, :outs_pitched},
      {:split_id, :split}
    ],
    schema: Pitching.Game

  def update_changeset(%Ecto.Changeset{} = changeset) do
    changeset
    |> Pitching.Game.put_composite_key()
    |> add_missing_statistics()
    |> round_statistic(:win_probability_added)
    |> round_statistic(:leverage_index)
  end

  def sanitize_attributes(%{team_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | team_id: nil})
  end

  def sanitize_attributes(%{league_id: league_id} = attrs) do
    league_id = if String.to_integer(league_id) < 1, do: nil, else: league_id

    %{attrs | league_id: league_id}
  end

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            team_id: team_id,
            game_id: game_id
          }
        } = _changeset
      ) do
    OOTPUtility.Imports.Agent.in_cache?(:teams, team_id) &&
      OOTPUtility.Imports.Agent.in_cache?(:games, game_id)
  end
end
