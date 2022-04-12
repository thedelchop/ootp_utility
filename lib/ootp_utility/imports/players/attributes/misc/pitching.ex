defmodule OOTPUtility.Imports.Players.Attributes.Misc.Pitching do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_pitching",
    headers: [
      {:pitching_ratings_misc_velocity, :velocity},
      {:pitching_ratings_misc_arm_slot, :arm_slot},
      {:pitching_ratings_misc_stamina, :stamina},
      {:pitching_ratings_misc_ground_fly, :groundball_flyball_ratio},
      {:pitching_ratings_misc_hold, :hold_runners},
      {:player_id, :id}
    ],
    schema: Players.Player

  def sanitize_attributes(
        %{
          id: id,
          velocity: velocity,
          arm_slot: arm_slot,
          stamina: stamina,
          groundball_flyball_ratio: gb_fb_ratio,
          hold_runners: hold_runners
        } = _attrs
      ) do
    %{
      id: id,
      velocity: as_enum(:velocity, velocity),
      arm_slot: as_enum(:arm_slot, arm_slot),
      stamina: stamina,
      groundball_flyball_ratio: as_enum(:groundball_flyball_ratio, gb_fb_ratio),
      hold_runners: hold_runners
    }
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Player, attrs,
      on_conflict:
        {:replace, [:velocity, :arm_slot, :stamina, :groundball_flyball_ratio, :hold_runners]},
      conflict_target: [:id]
    )

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{id: player_id}} = _) do
    Imports.ImportAgent.in_cache?(:players, player_id)
  end

  defp as_enum(:groundball_flyball_ratio, raw_value) do
    value = String.to_integer(raw_value)

    cond do
      value > 63 ->
        :extreme_groundball

      value > 58 ->
        :groundball

      value > 48 ->
        :neutral

      value > 43 ->
        :flyball

      true ->
        :extreme_flyball
    end
  end

  defp as_enum(enum_name, dump_value) do
    Players.Player
    |> Ecto.Enum.mappings(enum_name)
    |> Enum.find({nil}, fn {_k, v} -> v == String.to_integer(dump_value) end)
    |> elem(0)
  end
end
