defmodule OOTPUtility.Imports.Statistics.Batting.Team do
  alias OOTPUtility.{Repo, Teams}
  alias OOTPUtility.Statistics.Batting

  import Ecto.Query, only: [from: 2]

  use OOTPUtility.Imports.Statistics.Batting,
    from: "team_batting_stats.csv",
    headers: [
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
    ],
    schema: Batting.Team

  def update_changeset(changeset) do
    changeset
    |> Batting.Team.put_composite_key()
  end

  def should_import?(%{league_id: "0"} = _attrs), do: false
  def should_import?(_attrs), do: true

  def validate_changeset(
        %Ecto.Changeset{
          changes: %{
            team_id: team_id
          }
        } = _changeset
      ) do
    Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
  end
end
