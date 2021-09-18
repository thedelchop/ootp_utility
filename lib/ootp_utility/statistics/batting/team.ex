defmodule OOTPUtility.Statistics.Batting.Team do
  @type t() :: %__MODULE__{}

  alias OOTPUtility.{Imports, Leagues, Repo, Schema, Teams, Utilities}

  import Ecto.Query, only: [from: 2]

  use Schema

  use Imports, attributes: [
    :id, :team_id, :year, :league_id, :level_id, :split_id,
    :plate_appearances, :at_bats, :hits, :strikeouts, :total_bases,
    :singles, :doubles, :triples, :home_runs, :stolen_bases, :caught_stealing,
    :runs_batted_in, :runs, :walks, :intentional_walks, :hit_by_pitch,
    :sacrifices, :sacrifice_flys, :catchers_interference, :double_plays,
    :games, :games_started, :extra_base_hits, :batting_average,
    :on_base_percentage, :slugging, :runs_created, :runs_created_per_27_outs,
    :isolated_power, :weighted_on_base_average, :on_base_plus_slugging, :stolen_base_percentage
    ],
    from: "team_batting_stats.csv"

  schema "team_batting_stats" do
    field :runs_created, :float
    field :doubles, :integer
    field :runs_created_per_27_outs, :float
    field :caught_stealing, :integer
    field :extra_base_hits, :integer
    field :runs, :integer
    field :level_id, :string
    field :slugging, :float
    field :triples, :integer
    field :strikeouts, :integer
    field :stolen_base_percentage, :float
    field :batting_average, :float
    field :intentional_walks, :integer
    field :runs_batted_in, :integer
    field :on_base_plus_slugging, :float
    field :double_plays, :integer
    field :walks, :integer
    field :on_base_percentage, :float
    field :total_bases, :integer
    field :sacrifices, :integer
    field :at_bats, :integer
    field :games_started, :integer
    field :hit_by_pitch, :integer
    field :singles, :integer
    field :split_id, :integer
    field :plate_appearances, :integer
    field :isolated_power, :float
    field :home_runs, :integer
    field :hits, :integer
    field :stolen_bases, :integer
    field :games, :integer
    field :sacrifice_flys, :integer
    field :year, :integer
    field :weighted_on_base_average, :float
    field :catchers_interference, :integer

    belongs_to :team, Teams.Team
    belongs_to :league, Leagues.League
  end

  def update_import_changeset(changeset) do
    changeset
    |> put_id()
  end

  def sanitize_attributes(attrs),
    do: Utilities.rename_keys(attrs, [
      {:pa, :plate_appearances},
      {:ab, :at_bats},
      {:h, :hits},
      {:k, :strikeouts},
      {:tb, :total_bases},
      {:s, :singles},
      {:d, :doubles},
      {:t, :triples},
      {:hr, :home_runs},
      {:sb, :stolen_bases},
      {:cs, :caught_stealing},
      {:rbi, :runs_batted_in},
      {:r, :runs},
      {:bb, :walks},
      {:ibb, :intentional_walks},
      {:hp, :hit_by_pitch},
      {:sh, :sacrifices},
      {:sf, :sacrifice_flys},
      {:ci, :catchers_interference},
      {:gdp, :double_plays},
      {:g, :games},
      {:gs, :games_started},
      {:ebh, :extra_base_hits},
      {:avg, :batting_average},
      {:obp, :on_base_percentage},
      {:slg, :slugging},
      {:rc, :runs_created},
      {:rc27, :runs_created_per_27_outs},
      {:iso, :isolated_power},
      {:woba, :weighted_on_base_average},
      {:ops, :on_base_plus_slugging},
      {:sbp, :stolen_base_percentage}
  ])

  def valid_for_import?(%{league_id: "0"} = _attrs), do: false

  def valid_for_import?(%{team_id: team_id} = _attrs) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end

  defp put_id(%Ecto.Changeset{changes: %{team_id: team_id}} = changeset),
    do: change(changeset, %{id: team_id})
end
