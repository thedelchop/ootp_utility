defmodule OOTPUtility.Imports.Players.Player do
  alias OOTPUtility.Imports
  import OOTPUtility.Utilities, only: [position_from_scoring_key: 1]

  @handedness [nil, "right", "left", "switch"]

  use Imports,
    from: "players",
    headers: [
      {:player_id, :id},
      {:local_pop, :local_popularity},
      {:national_pop, :national_popularity}
    ],
    schema: OOTPUtility.Players.Player,
    slug: [:first_name, :last_name]

  def should_import?(%{retired: "1"} = _attrs), do: false
  def should_import?(_attrs), do: true

  def sanitize_attributes(%{team_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | team_id: nil})
  end

  def sanitize_attributes(%{organization_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | organization_id: nil})
  end

  def sanitize_attributes(%{position: position, role: "0"} = attrs) do
    {:ok, position} = position_from_scoring_key(position)

    sanitize_attributes(%{attrs | position: position, role: nil})
  end

  def sanitize_attributes(%{role: role} = attrs) when not is_nil(role) do
    {:ok, position} = position_from_scoring_key(role)

    sanitize_attributes(%{attrs | position: position, role: nil})
  end

  def sanitize_attributes(
        %{
          league_id: league_id,
          bats: bats,
          throws: throws,
          date_of_birth: date_of_birth_as_string
        } = attrs
      ) do
    with {:ok, date_of_birth} <- Timex.parse(date_of_birth_as_string, "{YYYY}-{M}-{D}") do
      league_id = if String.to_integer(league_id) < 1, do: nil, else: league_id

      %{
        attrs
        | league_id: league_id,
          date_of_birth: date_of_birth,
          bats: Enum.at(@handedness, String.to_integer(bats)),
          throws: Enum.at(@handedness, String.to_integer(throws))
      }
    end
  end

  def validate_changeset(%Ecto.Changeset{changes: %{team_id: team_id}} = _) do
    Imports.Agent.in_cache?(:teams, team_id)
  end

  def validate_changeset(_changeset), do: true
end
