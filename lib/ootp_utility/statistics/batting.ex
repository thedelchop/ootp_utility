defmodule OOTPUtility.Statistics.Batting do
  @moduledoc """
  The Statistics.Batting context.
  """
  import Ecto.Query, warn: false

  alias __MODULE__
  alias OOTPUtility.{Repo, Teams}

  def ranking(%Teams.Team{id: team_id} = _team, statistic, partition) do
    order_by = [desc: statistic]
    partition = [String.to_atom("#{partition}_id"), :year]

    ranking_query =
      from s in Batting.Team,
        select: %{
          position: over(rank(), :rankings),
          count: over(count(), :partition),
          id: s.id
        },
        windows: [
          rankings: [partition_by: ^partition, order_by: ^order_by],
          partition: [partition_by: ^partition]
        ],
        group_by: s.id

    query =
      from stats in Batting.Team,
        join: r in subquery(ranking_query),
        on: stats.id == r.id,
        select: {r.position, r.count, field(stats, ^statistic)},
        where: stats.team_id == ^team_id

    Repo.one(query)
  end
end
