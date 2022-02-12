defmodule OOTPUtility.Imports.Players.Attributes.Running do
  alias OOTPUtility.{Imports, Players}

  use Imports,
    from: "players",
    headers: [
      {:running_ratings_speed, :speed},
      {:running_ratings_stealing, :stealing},
      {:running_ratings_baserunning, :baserunning}
    ],
    schema: Players.Attribute

  def sanitize_attributes(
        %{
          speed: speed,
          baserunning: baserunning,
          stealing: stealing,
          player_id: player_id
        } = _attrs
      ) do
    [
      %{name: "speed", type: :ability, value: speed, player_id: player_id},
      %{name: "stealing", type: :ability, value: stealing, player_id: player_id},
      %{name: "baserunning", type: :ability, value: baserunning, player_id: player_id}
    ]
    |> Enum.reject(fn
      %{value: "0"} -> true
      _ -> false
    end)
  end

  def write_records_to_database(attrs) do
    OOTPUtility.Repo.insert_all(Players.Attribute, attrs)

    {[], attrs}
  end

  def validate_changeset(%Ecto.Changeset{changes: %{player_id: player_id}} = _) do
    Imports.Agent.in_cache?(:players, player_id)
  end
end
