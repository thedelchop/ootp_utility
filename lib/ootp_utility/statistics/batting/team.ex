defmodule OOTPUtility.Statistics.Batting.Team do
  alias OOTPUtility.{Repo, Teams, Utilities}
  alias OOTPUtility.Statistics.Batting

  import Ecto.Query, only: [from: 2]

  use Batting.Schema,
    from: "team_batting_stats.csv",
    composite_key: [:team_id, :year],
    foreign_key: [:id, :year]

  batting_schema "team_batting_stats" do
    field :weighted_on_base_average, :float
    field :runs_created_per_27_outs, :float
  end

  def sanitize_batting_attributes(attrs),
    do:
      Utilities.rename_keys(attrs, [
        {:avg, :batting_average},
        {:ebh, :extra_base_hits},
        {:iso, :isolated_power},
        {:obp, :on_base_percentage},
        {:ops, :on_base_plus_slugging},
        {:rc, :runs_created},
        {:rc27, :runs_created_per_27_outs},
        {:s, :singles},
        {:sbp, :stolen_base_percentage},
        {:slg, :slugging},
        {:tb, :total_bases},
        {:woba, :weighted_on_base_average}
      ])

  def valid_for_import?(%{league_id: "0"} = _attrs), do: false

  def valid_for_import?(%{team_id: team_id} = _attrs) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end
end
