defmodule OOTPUtility.Repo.Migrations.RemoveDivisionConferenceForeignKeysFromTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      modify(:conference_id, :string, from: references(:conferences, on_delete: :delete_all))
      modify(:division_id, :string, from: references(:divisions, on_delete: :delete_all))
    end
  end
end
