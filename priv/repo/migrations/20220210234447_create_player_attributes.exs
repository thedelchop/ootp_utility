defmodule OOTPUtility.Repo.Migrations.CreatePlayerAttributes do
  use Ecto.Migration

  import OOTPUtility.Players.Attribute,
    only: [
      batting_attributes: 0,
      pitching_attributes: 0,
      fielding_attributes: 0,
      baserunning_attributes: 0,
      bunting_attributes: 0,
      positions: 0,
      pitches: 0
    ]

  def change do
    create table(:player_attributes, primary_key: false) do
      add :name, :string
      add :type, :integer
      add :value, :integer
      add :player_id, references(:players, on_delete: :delete_all)
    end

    create index(:player_attributes, [:player_id])

    create create_partial_name_index(batting_attributes(), :player_batting_attributes_index)
    create create_partial_name_index(pitching_attributes(), :player_pitching_attributes_index)
    create create_partial_name_index(fielding_attributes(), :player_fielding_attributes_index)

    create create_partial_name_index(
             baserunning_attributes(),
             :player_baserunning_attributes_index
           )

    create create_partial_name_index(bunting_attributes(), :player_bunting_attributes_index)
    create create_partial_name_index(positions(), :player_position_attributes_index)

    create create_partial_name_index(pitches(), :player_pitches_index)
  end

  defp create_partial_name_index(names, index_name) do
    index(
      :player_attributes,
      [:player_id, :name],
      where: "name IN (#{Enum.map(names, &"'#{&1}'") |> Enum.join(", ")})",
      name: index_name
    )
  end
end
