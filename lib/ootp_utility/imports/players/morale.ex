defmodule OOTPUtility.Imports.Players.Morale do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players",
    headers: [
      {:morale_player_performance, :personal_performance},
      {:morale_team_performance, :team_performance},
      {:morale_team_transactions, :team_transactions},
      {:morale_player_role, :role_on_team}
    ],
    schema: Players.Morale

  def sanitize_attributes(
        %{
          personal_performance: personal_performance,
          team_performance: team_performance,
          team_transactions: team_transactions,
          role_on_team: role_on_team,
          player_id: player_id
        } = attrs
      ) do
    %{
      attrs
      | personal_performance: convert_morale_value(personal_performance),
        team_performance: convert_morale_value(team_performance),
        team_transactions: convert_morale_value(team_transactions),
        role_on_team: convert_player_role_value(role_on_team)
    }
    |> Map.put(:id, player_id)
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Morale, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end

  defp convert_player_role_value(value_as_string) do
    value_as_string
    |> String.to_integer()
    |> do_convert_morale_value(10)
  end

  defp convert_morale_value(value_as_string) do
    value_as_string
    |> String.to_integer()
    |> do_convert_morale_value()
  end

  defp do_convert_morale_value(value_as_int, scale \\ 1) do
    cond do
      value_as_int < -395 * scale ->
        :angry

      value_as_int < -195 * scale ->
        :very_unhappy

      value_as_int < -95 * scale ->
        :unhappy

      value_as_int < 55 * scale ->
        :normal

      value_as_int < 255 * scale ->
        :good

      value_as_int < 405 * scale ->
        :very_good

      value_as_int >= 405 * scale ->
        :great
    end
  end
end
