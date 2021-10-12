defmodule OOTPUtility.Imports.Players.Player do
  alias OOTPUtility.{Repo, Teams}

  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports,
    from: "players.csv",
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

  def sanitize_attributes(%{league_id: league_id} = attrs) do
    if String.to_integer(league_id) < 1, do: %{attrs | league_id: nil}, else: attrs
  end

  def validate_changeset(%Ecto.Changeset{changes: %{team_id: team_id}} = _changeset) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end

  def validate_changeset(_changeset), do: true
end
