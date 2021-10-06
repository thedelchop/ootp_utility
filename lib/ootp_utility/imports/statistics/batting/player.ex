defmodule OOTPUtility.Imports.Statistics.Batting.Player do
  alias OOTPUtility.{Repo, Teams}
  alias OOTPUtility.Statistics.Batting

  import OOTPUtility.Imports.Statistics.Batting, only: [add_missing_statistics: 1]
  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports.Statistics.Batting,
    from: "players_career_batting_stats.csv",
    schema: Batting.Player

  def update_changeset(changeset) do
    changeset
    |> Batting.Player.put_composite_key()
    |> add_missing_statistics()
  end

  def should_import?(%{league_id: "0"} = _attrs), do: false
  def should_import?(_attrs), do: true

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
            team_id: team_id
          }
        } = _changeset
      ) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end

  def validate_changeset(_changeset), do: true
end
