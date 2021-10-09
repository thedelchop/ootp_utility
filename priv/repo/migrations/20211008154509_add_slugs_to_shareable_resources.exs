defmodule OOTPUtility.Repo.Migrations.AddSlugsToShareableResources do
  use Ecto.Migration

  def change do
    shareable_schemas = [
      :leagues,
      :conferences,
      :divisions,
      :teams,
      :players
    ]

    for schema <- shareable_schemas do
      alter table(schema) do
        add :slug, :string
      end
    end

    create unique_index(:leagues, [:slug])
    create unique_index(:conferences, [:league_id, :slug])
    create unique_index(:divisions, [:league_id, :conference_id, :slug])
  end
end
