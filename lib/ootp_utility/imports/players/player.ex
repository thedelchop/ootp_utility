defmodule OOTPUtility.Imports.Players.Player do
  alias OOTPUtility.Imports

  use Imports,
    from: "players.csv",
    headers: [
      {:player_id, :id},
      {:local_pop, :local_popularity},
      {:national_pop, :national_popularity}
    ],
    schema: OOTPUtility.Players.Player,
    slug: [:first_name, :last_name],
    cache: true

  def should_import?(%{retired: "1"} = _attrs), do: false
  def should_import?(_attrs), do: true

  def sanitize_attributes(%{team_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | team_id: nil})
  end

  def sanitize_attributes(%{organization_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | organization_id: nil})
  end

  def sanitize_attributes(%{league_id: league_id} = attrs) do
    if String.to_integer(league_id) < 1, do: %{attrs | league_id: nil}, else: attrs
  end

  def validate_changeset(%Ecto.Changeset{changes: %{team_id: team_id}} = _) do
    Imports.Agent.in_cache?(:teams, team_id)
  end

  def validate_changeset(_changeset), do: true
end
