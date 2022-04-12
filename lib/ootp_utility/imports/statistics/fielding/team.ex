defmodule OOTPUtility.Imports.Statistics.Fielding.Team do
  alias OOTPUtility.Statistics.Fielding

  import OOTPUtility.Imports.Statistics.Fielding, only: [calculate_outs_played: 1]
  import OOTPUtility.Utilities, only: [league_level_from_id: 1]

  use OOTPUtility.Imports.Statistics.Fielding,
    from: "team_fielding_stats_stats",
    schema: Fielding.Team,
    headers: [{:level_id, :level}]

  def update_changeset(changeset) do
    changeset
    |> Fielding.Team.put_composite_key()
  end

  def sanitize_attributes(%{level: level_id} = attrs) do
    attrs
    |> Map.put(:outs_played, calculate_outs_played(attrs))
    |> Map.put(:level, league_level_from_id(level_id))
  end

  def should_import?(%{league_id: "0"} = _attrs), do: false
  def should_import?(%{level: "0"} = _attrs), do: false
  def should_import?(_attrs), do: true

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            team_id: team_id
          }
        } = _changeset
      ) do
    OOTPUtility.Imports.ImportAgent.in_cache?(:teams, team_id)
  end
end
