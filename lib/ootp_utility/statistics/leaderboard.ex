defmodule OOTPUtility.Statistics.Leaderboard do
  defstruct [:statistic, :leaders]

  @moduledoc """
  This module provides a structure to represent the statistical
  leaders for a population, either players or teams for a specific
  statistic.
  """
  import Ecto.Query

  alias __MODULE__
  alias OOTPUtility.{Players, Repo}

  def new(schema, statistic, scope) do
    %Leaderboard{
      statistic: statistic,
      leaders: leaders_for(schema, statistic, scope)
    }
  end

  defp leaders_for(schema, field, scope) do
    schema
    |> where(^scope)
    |> join(:inner, [stats], p in Players.Player, on: stats.player_id == p.id)
    |> order_by([stats], desc: ^field)
    |> limit(5)
    |> select([stats, p], %Leaderboard.Leader{subject: p, value: field(stats, ^field)})
    |> Repo.all()
  end

  defmodule Leader do
    defstruct [:subject, :value]

    alias __MODULE__

    def new(%{subject: subject, value: value} = _attrs) do
      %Leader{
        subject: subject,
        value: value
      }
    end
  end
end
