defmodule OOTPUtility.Imports.Statistics.Pitching.Game do
  alias OOTPUtility.Statistics.Pitching

  import OOTPUtility.Imports.Statistics.Pitching, only: [add_missing_statistics: 1]

  use OOTPUtility.Imports.Statistics.Pitching,
    from: "players_game_pitching_stats",
    headers: [
      {:ir, :inherited_runners},
      {:irs, :inherited_runners_scored},
      {:li, :leverage_index},
      {:wpa, :win_probability_added},
      {:outs, :outs_pitched}
    ],
    schema: Pitching.Game

  def update_changeset(
        %Ecto.Changeset{
          changes: %{win_probability_added: wpa, leverage_index: li}
        } = changeset
      ) do
    changeset
    |> Pitching.Game.put_composite_key()
    |> add_missing_statistics()
    |> Ecto.Changeset.change(%{
      win_probability_added: Float.round(wpa, 2),
      leverage_index: Float.round(li, 2)
    })
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
