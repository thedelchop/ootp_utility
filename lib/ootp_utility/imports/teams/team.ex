defmodule OOTPUtility.Imports.Teams.Team do
  alias OOTPUtility.Leagues.{Conference, Division}

  import Ecto.Changeset, only: [change: 2]
  import OOTPUtility.Imports.Helpers, only: [convert_league_level: 1]

  use OOTPUtility.Imports,
    from: "teams",
    headers: [
      {:sub_league_id, :conference_id},
      {:team_id, :id},
      {:logo_file_name, :logo_filename}
    ],
    schema: OOTPUtility.Teams.Team,
    slug: [:name, :nickname]

  def sanitize_attributes(%{level: league_level} = attrs) do
    %{attrs | level: convert_league_level(league_level)}
  end

  def update_changeset(changeset) do
    changeset
    |> put_division_id()
    |> put_conference_id()
  end

  def should_import?(%{allstar_team: "1"} = _attrs), do: false
  def should_import?(_attrs), do: true

  defp put_division_id(%Ecto.Changeset{changes: changes} = changeset) do
    with division_id <- Division.generate_foreign_key(changes) do
      if OOTPUtility.Imports.ImportAgent.in_cache?(:divisions, division_id) do
        change(changeset, %{division_id: division_id})
      else
        change(changeset, %{division_id: nil})
      end
    end
  end

  defp put_conference_id(%Ecto.Changeset{changes: changes} = changeset) do
    with conference_id <- Conference.generate_foreign_key(changes) do
      if OOTPUtility.Imports.ImportAgent.in_cache?(:conferences, conference_id) do
        change(changeset, %{conference_id: conference_id})
      else
        change(changeset, %{conference_id: nil})
      end
    end
  end
end
