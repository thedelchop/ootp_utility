defmodule OOTPUtility.Repo.Migrations.CreateTeamBattingStats do
  use Ecto.Migration

  def change do
    create table(:team_batting_stats) do
      add :level_id, :integer
      add :split_id, :integer
      add :year, :integer

      add :plate_appearances, :integer
      add :at_bats, :integer
      add :hits, :integer
      add :strikeouts, :integer
      add :total_bases, :integer
      add :singles, :integer
      add :doubles, :integer
      add :triples, :integer
      add :home_runs, :integer
      add :stolen_bases, :integer
      add :caught_stealing, :integer
      add :runs_batted_in, :integer
      add :runs, :integer
      add :walks, :integer
      add :intentional_walks, :integer
      add :hit_by_pitch, :integer
      add :sacrifices, :integer
      add :sacrifice_flys, :integer
      add :catchers_interference, :integer
      add :double_plays, :integer
      add :games, :integer
      add :games_started, :integer
      add :extra_base_hits, :integer
      add :batting_average, :float
      add :on_base_percentage, :float
      add :slugging, :float
      add :runs_created, :float
      add :runs_created_per_27_outs, :float
      add :isolated_power, :float
      add :weighted_on_base_average, :float
      add :on_base_plus_slugging, :float
      add :stolen_base_percentage, :float

      add :team_id, references(:teams, on_delete: :delete_all)
      add :league_id, references(:leagues, on_delete: :delete_all)
    end

    create index(:team_batting_stats, [:team_id])
    create index(:team_batting_stats, [:league_id])
  end
end
