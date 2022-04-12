defmodule OOTPUtility.Imports.Players.Personality do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players",
    headers: [
      {:personality_greed, :greed},
      {:personality_loyalty, :loyalty},
      {:personality_play_for_winner, :desire_to_win},
      {:personality_work_ethic, :work_ethic},
      {:personality_intelligence, :intelligence},
      {:personality_leader, :leadership}
    ],
    schema: Players.Personality

  def sanitize_attributes(
        %{
          greed: greed,
          loyalty: loyalty,
          desire_to_win: desire_to_win,
          work_ethic: work_ethic,
          intelligence: intelligence,
          leadership: leadership,
          player_id: player_id
        } = attrs
      ) do
    %{
      attrs
      | greed: convert_personality_value(greed),
        loyalty: convert_personality_value(loyalty),
        desire_to_win: convert_personality_value(desire_to_win),
        work_ethic: convert_personality_value(work_ethic),
        intelligence: convert_personality_value(intelligence),
        leadership: convert_personality_value(leadership)
    }
    |> Map.put(:id, player_id)
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Personality, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.ImportAgent.in_cache?(:players, player_id)
  end

  defp convert_personality_value(value_as_string) do
    value_as_int = String.to_integer(value_as_string)

    cond do
      value_as_int < 60 ->
        :low

      value_as_int < 140 ->
        :normal

      value_as_int <= 200 ->
        :high
    end
  end
end
