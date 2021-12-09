defmodule OOTPUtility.Imports.Statistics.Batting.Game do
  alias OOTPUtility.Statistics.Batting

  import OOTPUtility.Imports.Statistics.Batting, only: [add_missing_statistics: 1]

  use OOTPUtility.Imports.Statistics.Batting,
    from: "players_game_batting",
    headers: [
      {:wpa, :win_probability_added},
    ],
    schema: Batting.Game

  def update_changeset(%Ecto.Changeset{
      changes: %{
        win_probability_added: wpa
      }
    } = changeset) do
    changeset
    |> Batting.Game.put_composite_key()
    |> add_missing_statistics()
    |> Ecto.Changeset.change(%{
      win_probability_added: Float.round(wpa, 2)
    })
  end

  def should_import?(%{league_id: "0"} = _attrs), do: false
  def should_import?(_attrs), do: true

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
