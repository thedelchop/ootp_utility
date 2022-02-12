defmodule OOTPUtility.Imports.Players.Attributes do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_value",
    headers: [
      {:oa, :ability},
      {:pot, :talent},
      {:player_id, :id}
    ],
    schema: Players.Player

  def sanitize_attributes(attrs), do: Map.take(attrs, [:id, :ability, :talent])

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Player, attrs,
      on_conflict: {:replace, [:ability, :talent]},
      conflict_target: [:id]
    )

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
