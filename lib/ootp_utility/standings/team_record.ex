defmodule OOTPUtility.Standings.TeamRecord do
  @type t() :: %__MODULE__{}

  alias OOTPUtility.{Imports, Repo, Schema, Utilities}
  alias OOTPUtility.Teams.Team

  use Schema

  import Ecto.Query, only: [from: 2]

  use Imports,
    attributes: [
      :id,
      :games,
      :wins,
      :losses,
      :position,
      :winning_percentage,
      :games_behind,
      :streak,
      :magic_number,
      :team_id
    ],
    from: "team_record.csv"

  schema "team_records" do
    field :games, :integer
    field :games_behind, :float
    field :losses, :integer
    field :magic_number, :integer
    field :position, :integer
    field :streak, :integer
    field :winning_percentage, :float
    field :wins, :integer

    belongs_to :team, Team
  end

  def update_import_changeset(changeset) do
    changeset
    |> put_id()
  end

  @spec sanitize_attributes(map()) :: map()
  def sanitize_attributes(%{} = attrs) do
    attrs
    |> Utilities.rename_keys([
      {:gb, :games_behind},
      {:l, :losses},
      {:w, :wins},
      {:pct, :winning_percentage},
      {:g, :games},
      {:pos, :position}
    ])
  end

  def valid_for_import?(%{team_id: team_id} = _attrs) do
    Repo.exists?(from t in Team, where: t.id == ^team_id)
  end

  defp put_id(%Ecto.Changeset{changes: changes} = changeset) do
    change(changeset, %{id: changes.team_id})
  end
end