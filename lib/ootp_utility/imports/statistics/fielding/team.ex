defmodule OOTPUtility.Imports.Statistics.Fielding.Team do
  alias OOTPUtility.{Repo, Teams}
  alias OOTPUtility.Statistics.Fielding

  import Ecto.Query, only: [from: 2]
  import OOTPUtility.Imports.Statistics.Fielding, only: [calculate_outs_played: 1]

  use OOTPUtility.Imports.Statistics.Fielding,
    from: "team_fielding_stats_stats.csv",
    schema: Fielding.Team

  def update_changeset(changeset) do
    changeset
    |> Fielding.Team.put_composite_key()
  end

  def sanitize_attributes(attrs) do
    attrs
    |> Map.put(:outs_played, calculate_outs_played(attrs))
  end

  def should_import?(%{league_id: "0"} = _attrs), do: false
  def should_import?(_attrs), do: true

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            team_id: team_id
          }
        } = _changeset
      ) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end
end
