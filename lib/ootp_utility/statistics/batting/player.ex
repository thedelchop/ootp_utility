defmodule OOTPUtility.Statistics.Batting.Player do
  alias OOTPUtility.{Imports, Leagues, Players, Teams, Utilities}

  use Imports.Schema,
    from: "players_career_batting_stats.csv",
    composite_key: [:year, :team_id, :player_id, :split_id]

  import_schema "players_career_batting_stats" do
    field :position, :integer

    field :split_id, :integer
    field :level_id, :integer
    field :year, :integer

    field :games, :integer
    field :games_started, :integer

    field :at_bats, :integer
    field :plate_appearances, :integer
    field :pitches_seen, :integer

    field :hits, :integer
    field :doubles, :integer
    field :triples, :integer
    field :home_runs, :integer

    field :strikeouts, :integer
    field :walks, :integer
    field :intentional_walks, :integer
    field :hit_by_pitch, :integer
    field :catchers_interference, :integer

    field :runs, :integer
    field :runs_batted_in, :integer

    field :grounded_into_double_play, :integer
    field :sacrifice_flys, :integer
    field :sacrifices, :integer

    field :stolen_bases, :integer
    field :caught_stealing, :integer

    field :ubr, :float
    field :war, :float
    field :wpa, :float

    belongs_to :league, Leagues.League
    belongs_to :team, Teams.Team
    belongs_to :player, Players.Player
  end

  def update_import_changeset(changeset), do: put_composite_key(changeset)

  def sanitize_attributes(%{team_id: "0"} = attrs) do
    sanitize_attributes(%{attrs | team_id: nil})
  end

  def sanitize_attributes(%{league_id: league_id} = attrs) do
    attrs = if String.to_integer(league_id) < 1, do: %{attrs | league_id: nil}, else: attrs

    Utilities.rename_keys(attrs, [
      {:ab, :at_bats},
      {:bb, :walks},
      {:ci, :catchers_interference},
      {:cs, :caught_stealing},
      {:d, :doubles},
      {:g, :games},
      {:gdp, :grounded_into_double_play},
      {:gs, :games_started},
      {:h, :hits},
      {:hp, :hit_by_pitch},
      {:hr, :home_runs},
      {:ibb, :intentional_walks},
      {:k, :strikeouts},
      {:pa, :plate_appearances},
      {:r, :runs},
      {:rbi, :runs_batted_in},
      {:sb, :stolen_bases},
      {:sf, :sacrifice_flys},
      {:sh, :sacrifices},
      {:t, :triples}
    ])
  end
end
