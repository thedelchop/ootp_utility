defmodule OOTPUtility.Statistics.Leaderboard do
  defstruct [:statistic, :leaders]

  @moduledoc """
  This module provides a structure to represent the statistical
  leaders for a population, either players or teams for a specific
  statistic.
  """
  import Ecto.Query
  import OOTPUtility.Statistics, only: [is_prevention_stat: 1]

  alias __MODULE__
  alias OOTPUtility.{Players, Repo}

  def new(query, statistic) do
    %Leaderboard{
      statistic: statistic,
      leaders: leaders_for(query, statistic)
    }
  end

  defp leaders_for(query, field) when is_prevention_stat(field) do
    do_leaders_for(query, field, :asc)
  end

  defp leaders_for(query, field), do: do_leaders_for(query, field)

  defp do_leaders_for(query, field, sort_order \\ :desc) do
    query
    |> join(:inner, [stats], p in Players.Player, on: stats.player_id == p.id)
    |> order_by([stats], [{^sort_order, ^field}])
    |> limit(5)
    |> select([stats, p], %{subject: p, value: field(stats, ^field)})
    |> Repo.all()
    |> Enum.map(&Leaderboard.Leader.new/1)
  end

  defmodule Leader do
    defstruct [:subject, :value]

    alias __MODULE__

    def new(%{value: value} = attrs) when is_float(value) and value < 1 do
      "0" <> float = value |> :erlang.float_to_binary(decimals: 3)

      new(%{attrs | value: float})
    end

    def new(%{value: value} = attrs) when is_float(value) do
      float = value |> :erlang.float_to_binary(decimals: 3)

      new(%{attrs | value: float})
    end

    def new(%{subject: subject, value: value} = _attrs) do
      %Leader{
        subject: subject,
        value: value
      }
    end
  end
end
