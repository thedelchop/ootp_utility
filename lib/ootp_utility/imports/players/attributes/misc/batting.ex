defmodule OOTPUtility.Imports.Players.Attributes.Misc.Batting do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players_batting",
    headers: [
      {:batting_ratings_misc_gb_hitter_type, :groundball_hitter_type},
      {:batting_ratings_misc_fb_hitter_type, :flyball_hitter_type},
      {:player_id, :id}
    ],
    schema: Players.Player

  def sanitize_attributes(attrs) do
    Map.take(attrs, [:id, :groundball_hitter_type, :flyball_hitter_type])
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Player, attrs,
      on_conflict: {:replace, [:groundball_hitter_type, :flyball_hitter_type]},
      conflict_target: [:id]
    )

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
