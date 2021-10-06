defmodule OOTPUtility.Imports.Leagues.Division do
  alias OOTPUtility.Repo
  alias OOTPUtility.Leagues.{Conference, League}

  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports,
    from: "divisions.csv",
    headers: [{:sub_league_id, :conference_id}, {:division_id, :id}],
    schema: OOTPUtility.Leagues.Division

  def update_changeset(changeset) do
    changeset
    |> OOTPUtility.Leagues.Division.put_composite_key()
    |> put_conference_id()
  end

  def validate_changeset(
    %Ecto.Changeset{
      changes: %{
        league_id: league_id,
        conference_id: conference_id
      }
    } = _changeset) do
    Repo.exists?(from c in Conference, where: c.id == ^conference_id) &&
      Repo.exists?(from l in League, where: l.id == ^league_id)
  end

  defp put_conference_id(%Ecto.Changeset{changes: changes} = changeset) do
    with conference_id <- OOTPUtility.Leagues.Conference.generate_foreign_key(changes) do
      Ecto.Changeset.change(changeset, %{conference_id: conference_id})
    end
  end
end
