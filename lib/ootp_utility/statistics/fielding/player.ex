defmodule OOTPUtility.Statistics.Fielding.Player do
  alias OOTPUtility.{Players,Utilities}
  alias OOTPUtility.Statistics.Fielding

  use Fielding.Schema,
    from: "players_career_fielding_stats.csv",
    composite_key: [:player_id, :team_id, :year, :position]

  fielding_schema "players_career_fielding_stats" do
    field :zone_rating, :float
    field :reached_on_error, :integer
    field :position, :integer

    belongs_to :player, Players.Player
  end

  def sanitize_fielding_attributes(attrs) do
    Utilities.rename_keys(attrs, [
      {:roe, :reached_on_error},
      {:zr, :zone_rating}
    ])
  end

  def update_fielding_import_changeset(%Ecto.Changeset{} = changeset) do
    add_missing_statistics(changeset)
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

    change(changeset, %{stat_name => value})
  end

  defp calculate(%{total_chances: 0} = _attrs, :fielding_percentage), do: 0.0

  defp calculate(%{
            assists: a,
            put_outs: po,
            total_chances: tc
         } = _attrs,
         :fielding_percentage
       ), do: (a + po)/tc

  defp calculate(
         %{
            stolen_base_attempts: 0
         } = _,
         :runners_thrown_out_percentage
       ), do: 0.0

  defp calculate(
         %{
            runners_thrown_out: rto,
            stolen_base_attempts: sba
         } = _attrs,
         :runners_thrown_out_percentage
       ) do
       rto/sba
  end

  defp calculate(%{
      outs_played: 0
    },
    :range_factor), do: 0.0

  defp calculate(%{
      assists: a,
      put_outs: po,
      outs_played: outs_played
    },
    :range_factor) do
    (a + po)/(outs_played/27)
  end
end
