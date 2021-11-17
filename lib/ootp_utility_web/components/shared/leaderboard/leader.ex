defmodule OOTPUtilityWeb.Components.Shared.Leaderboard.Leader do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  import OOTPUtilityWeb.Helpers, only: [statistic_abbreviation: 1]

  use Surface.Component

  prop leader, :struct, required: true
  prop statistic, :string, required: true

  def name(leader) do
    "#{String.slice(leader.first_name, 0, 1)}. #{leader.last_name}"
  end

  def stat_abbreviation(statistic) do
    case statistic_abbreviation(statistic) do
      {:ok, abbr} -> abbr
      _ -> ""
    end
  end

  def render(assigns) do
    ~F"""
      <li class="flex flex-col flex-grow border-b py-2 relative">
        <div class="text-sm text-gray-700">{@statistic}</div>
        <div class="flex justify-between">
          <div class="my-1 text-base text-gray-700">{name(@leader)}</div>
          <div class="absolute top-4 right-0 text-large text-gray-900">{@leader.value}</div>
        </div>
        <div>
          <div class="text-sm text-gray-500">{@leader.position}</div>
          <div class="text-sm text-gray-500">{stat_abbreviation(@statistic)}</div>
        </div>
      </li>
    """
  end
end
