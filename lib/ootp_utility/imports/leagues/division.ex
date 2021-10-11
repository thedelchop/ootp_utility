defmodule OOTPUtility.Imports.Leagues.Division do
  alias OOTPUtility.{Leagues,Repo}

  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports,
    from: "divisions.csv",
    headers: [{:sub_league_id, :conference_id}, {:division_id, :id}],
    schema: Leagues.Division

  def should_import?(%{name: ""}), do: false
  def should_import?(_), do: true

  def update_changeset(changeset) do
    changeset
    |> Leagues.Division.put_composite_key()
    |> put_conference_id()
  end

  defp put_conference_id(%Ecto.Changeset{changes: changes} = changeset) do
    with conference_id <- Leagues.Conference.generate_foreign_key(changes) do
      if(Repo.exists?(from c in Leagues.Conference, where: c.id == ^conference_id)) do
        Ecto.Changeset.change(changeset, %{conference_id: conference_id})
      else
        Ecto.Changeset.change(changeset, %{conference_id: nil})
      end
    end
  end
end
