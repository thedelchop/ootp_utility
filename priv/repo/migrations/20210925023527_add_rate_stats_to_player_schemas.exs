defmodule OOTPUtility.Repo.Migrations.AddRateStatsToPlayerSchemas do
  use Ecto.Migration

  def change do
    add_missing_columns_for_player_stats(table(:players_career_batting_stats))
    add_missing_columns_for_player_stats(table(:players_game_batting_stats))

    alter table(:team_batting_stats), do: remove(:split_id, :integer)
    alter table(:players_career_batting_stats), do: remove(:position, :integer)
    alter table(:players_game_batting_stats), do: remove(:pitches_seen, :integer)
  end

  def add_missing_columns_for_player_stats(table) do
    alter table do
      add :singles, :integer
      add :extra_base_hits, :integer
      add :total_bases, :integer

      add :batting_average, :float
      add :on_base_percentage, :float
      add :slugging, :float
      add :on_base_plus_slugging, :float
      add :isolated_power, :float
      add :batting_average_on_balls_in_play, :float

      add :runs_created, :float

      add :stolen_base_percentage, :float
    end

    rename(table, :grounded_into_double_play, to: :double_plays)
  end
end
