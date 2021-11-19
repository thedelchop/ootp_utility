defmodule OOTPUtility.Statistics.Ranking do
  defstruct [:statistic, :rank, :value]

  @moduledoc """
  This module provides a structure to represent the statistical
  leaders for a population, either players or teams for a specific
  statistic.
  """
  # import Ecto.Query

  alias __MODULE__
  # alias OOTPUtility.{Teams, Repo}

  def new(schema, statistic, scope) do
    %Ranking{
      statistic: statistic,
      rank: rank_for_team(schema, statistic, scope),
      value: 100
    }
  end

  defp rank_for_team(_schema, _field, _scope) do
    1
  end
end
