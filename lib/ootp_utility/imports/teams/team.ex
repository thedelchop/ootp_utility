defmodule OOTPUtility.Imports.Teams.Team do
  alias OOTPUtility.Repo
  alias OOTPUtility.Leagues.{Conference, Division}

  import Ecto.Changeset, only: [change: 2]
  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports,
    from: "teams.csv",
    headers: [
      {:sub_league_id, :conference_id},
      {:team_id, :id},
      {:logo_file_name, :logo_filename}
    ],
    schema: OOTPUtility.Teams.Team

  def update_changeset(changeset) do
    changeset
    |> put_division_id()
    |> put_conference_id()
  end

  def should_import?(%{allstar_team: "1"} = _attrs), do: false
  def should_import?(_attrs), do: true

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            division_id: division_id,
            conference_id: conference_id
          }
        } = _changeset
      ) do
    Repo.exists?(from c in Conference, where: c.id == ^conference_id) &&
      Repo.exists?(from d in Division, where: d.id == ^division_id)
  end

  defp put_division_id(%Ecto.Changeset{changes: changes} = changeset) do
    with division_id <- Division.generate_foreign_key(changes) do
      change(changeset, %{division_id: division_id})
    end
  end

  defp put_conference_id(%Ecto.Changeset{changes: changes} = changeset) do
    with conference_id <- Conference.generate_foreign_key(changes) do
      change(changeset, %{conference_id: conference_id})
    end
  end
end
