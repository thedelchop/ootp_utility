defmodule OOTPUtility.Imports.Players.Ratings.Running do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players",
    headers: [
      {:running_ratings_speed, :speed},
      {:running_ratings_stealing, :stealing_ability},
      {:running_ratings_baserunning, :baserunning_ability}
    ],
    schema: Players.Ratings.Running

  def sanitize_attributes(%{player_id: player_id} = attrs), do: Map.put(attrs, :id,  player_id)

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Ratings.Running, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
