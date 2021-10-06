defmodule OOTPUtility.Imports.Statistics.Pitching.Player do
  alias OOTPUtility.{Repo, Teams, Players}
  alias OOTPUtility.Statistics.Pitching

  import OOTPUtility.Imports.Statistics.Pitching, only: [add_missing_statistics: 1]
  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports.Statistics.Pitching,
    from: "players_career_pitching_stats.csv",
    headers: [
      {:ir, :inherited_runners},
      {:irs, :inherited_runners_scored},
      {:li, :leverage_index},
      {:war, :wins_above_replacement},
      {:wpa, :win_probability_added},
      {:outs, :outs_pitched}
    ],
    schema: Pitching.Player

  def update_changeset(changeset) do
    changeset
    |> Pitching.Player.put_composite_key()
    |> add_missing_statistics()
  end

  def sanitize_attributes(%{team_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | team_id: nil})
  end

  def sanitize_attributes(%{league_id: league_id} = attrs) do
    if(String.to_integer(league_id) < 1) do
      %{attrs | league_id: nil}
    else
      attrs
    end
  end

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            team_id: team_id,
            player_id: player_id
          }
        } = _changeset
      ) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id) &&
      Repo.exists?(from p in Players.Player, where: p.id == ^player_id)
  end

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            team_id: team_id
          }
        } = _changeset
      ) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            player_id: player_id
          }
        } = _changeset
      ) do
    Repo.exists?(from p in Players.Player, where: p.id == ^player_id)
  end

  def validate_changeset(_changeset), do: true
end
