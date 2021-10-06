defmodule OOTPUtility.Imports.Statistics.Fielding.Player do
  alias OOTPUtility.{Repo, Teams}
  alias OOTPUtility.Statistics.Fielding

  import Ecto.Query, only: [from: 2]
  import OOTPUtility.Imports.Statistics.Fielding, only: [calculate_outs_played: 1]

  use OOTPUtility.Imports.Statistics.Fielding,
    from: "players_career_fielding_stats.csv",
    headers: [
      {:roe, :reached_on_error},
      {:zr, :zone_rating}
    ],
    schema: Fielding.Player

  def update_changeset(changeset) do
    changeset
    |> Fielding.Player.put_composite_key()
    |> add_missing_statistics()
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

  def add_missing_statistics(%Ecto.Changeset{} = changeset) do
    changeset
    |> add_statistic(:fielding_percentage)
    |> add_statistic(:runners_thrown_out_percentage)
    |> add_statistic(:range_factor)
  end

  defp add_statistic(%Ecto.Changeset{changes: attrs} = changeset, stat_name) do
    value = calculate(attrs, stat_name)
    value = if is_float(value), do: Float.round(value, 4), else: value

    Ecto.Changeset.change(changeset, %{stat_name => value})
  end

  defp calculate(%{total_chances: 0} = _attrs, :fielding_percentage), do: 0.0

  defp calculate(
         %{
           assists: a,
           put_outs: po,
           total_chances: tc
         } = _attrs,
         :fielding_percentage
       ),
       do: (a + po) / tc

  defp calculate(
         %{
           stolen_base_attempts: 0
         } = _,
         :runners_thrown_out_percentage
       ),
       do: 0.0

  defp calculate(
         %{
           runners_thrown_out: rto,
           stolen_base_attempts: sba
         } = _attrs,
         :runners_thrown_out_percentage
       ) do
    rto / sba
  end

  defp calculate(
         %{
           outs_played: 0
         },
         :range_factor
       ),
       do: 0.0

  defp calculate(
         %{
           assists: a,
           put_outs: po,
           outs_played: outs_played
         },
         :range_factor
       ) do
    (a + po) / (outs_played / 27)
  end
end
