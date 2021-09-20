defmodule OOTPUtility.Repo.Migrations.CreateTeamAffiliations do
  use Ecto.Migration

  def change do
    create table(:team_affiliations) do
      add :team_id, references(:teams, on_delete: :delete_all)
      add :affiliate_id, references(:teams, on_delete: :delete_all)
    end

    create index(:team_affiliations, [:team_id])
    create index(:team_affiliations, [:affiliate_id])
  end
end
