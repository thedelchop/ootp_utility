defmodule OOTPUtilityWeb.Components.Statistics.Leaderboard.Leader do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  import OOTPUtilityWeb.Helpers, only: [statistic_abbreviation: 1]
  import OOTPUtility.Utilities, only: [get_position_key: 1]

  alias OOTPUtility.Statistics.Leaderboard.Leader

  use Surface.Component

  prop leader, :struct, required: true
  prop statistic, :string, required: true

  def name(%Leader{subject: subject} = _leader) do
    "#{String.slice(subject.first_name, 0, 1)}. #{subject.last_name}"
  end

  def position(%Leader{subject: subject} = _leader), do: get_position_key(subject.position)

  def stat_abbreviation(statistic) do
    case statistic_abbreviation(statistic) do
      {:ok, abbr} -> abbr
      _ -> ""
    end
  end

  def humanized_statistic(statistic) do
    statistic
    |> Atom.to_string()
    |> Phoenix.Naming.humanize()
  end

  def render(assigns) do
    ~F"""
    <li class="flex flex-col flex-grow border-b last:border-none py-2 relative">
      <div class="text-sm text-gray-700 capitalize">{humanized_statistic(@statistic)}</div>
      <div class="flex justify-between">
        <div class="my-1 text-base text-gray-700">{name(@leader)}</div>
        <div class="absolute top-5 right-0 text-lg md:text-2xl text-gray-900">{@leader.value}</div>
      </div>
      <div class="flex justify-between">
        <div class="text-xs md:text-sm text-gray-500 uppercase">{position(@leader)}</div>
        <div class="text-xs md:text-sm text-gray-500 uppercase">{stat_abbreviation(@statistic)}</div>
      </div>
    </li>
    """
  end
end
