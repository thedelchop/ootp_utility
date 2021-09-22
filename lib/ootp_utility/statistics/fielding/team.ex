defmodule OOTPUtility.Statistics.Fielding.Team do
  alias OOTPUtility.{Imports, Leagues, Repo, Teams, Utilities}

  import Ecto.Query, only: [from: 2]

  use Imports.Schema, from: "team_fielding_stats_stats.csv"

  import_schema "team_fielding_stats" do
    field :assists, :integer
    field :catcher_earned_run_average, :float
    field :double_plays, :integer
    field :errors, :integer
    field :fielding_percentage, :float
    field :games, :integer
    field :games_started, :integer
    field :level_id, :integer
    field :outs_played, :integer
    field :past_balls, :integer
    field :put_outs, :integer
    field :range_factor, :float
    field :runners_thrown_out, :integer
    field :runners_thrown_out_percentage, :float
    field :stolen_base_attempts, :integer
    field :total_chances, :integer
    field :triple_plays, :integer
    field :year, :integer

    belongs_to :team, Teams.Team
    belongs_to :league, Leagues.League
  end

  def update_import_changeset(changeset) do
    changeset
    |> put_id()
  end

  def sanitize_attributes(attrs) do
    attrs
    |> Map.put(:outs_pitched, calculate_outs_played(attrs))
    |> rename_keys()
  end

  defp calculate_outs_played(%{ip: innings_played, ipf: innings_played_fraction} = _) do
    String.to_integer(innings_played) * 3 + String.to_integer(innings_played_fraction)
  end

  def rename_keys(attrs),
    do:
      Utilities.rename_keys(attrs, [
        {:g, :games},
        {:gs, :games_started},
        {:tc, :total_chances},
        {:a, :assists},
        {:po, :put_outs},
        {:e, :errors},
        {:dp, :double_plays},
        {:tp, :triple_plays},
        {:pb, :past_balls},
        {:sba, :stolen_base_attempts},
        {:rto, :runners_thrown_out},
        {:pct, :fielding_percentage},
        {:range, :range_factor},
        {:rtop, :runners_thrown_out_percentage},
        {:cera, :catcher_earned_run_average}
      ])

  def valid_for_import?(%{league_id: "0"} = _attrs), do: false

  def valid_for_import?(%{team_id: team_id} = _attrs) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end

  defp put_id(%Ecto.Changeset{changes: %{team_id: team_id}} = changeset),
    do: change(changeset, %{id: team_id})
end
