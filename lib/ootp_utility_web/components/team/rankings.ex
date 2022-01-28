defmodule OOTPUtilityWeb.Components.Team.Rankings do
  use Surface.Component

  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Statistics

  import OOTPUtilityWeb.Helpers, only: [ordinalize: 1]
  import Phoenix.Naming, only: [humanize: 1]

  prop team, :struct

  def render(assigns) do
    ~F"""
      <dl class="grid grid-cols-2 divide-x m-auto mt-2 md:m-0 rounded-lg bg-gray-50 overflow-hidden shadow divide-y divide-white-200">
        {#for {stat, {rank, total, value}} <- rankings(@team)}
          <div class="p-4">
            <dt class="text-base font-normal text-gray-900 whitespace-nowrap">
              {humanize(stat)}
            </dt>
            <dd class="mt-1 flex justify-between items-baseline">
              <div class="text-2xl font-semibold text-indigo-600">
                {value}
              </div>
              <div class="bg-green-100 text-green-800 mx-1 px-2.5 py-0.5 rounded-full text-sm font-medium lg:mt-2">
                {ordinalize(rank)}<span class="hidden lg:inline-flex">&nbsp;of {total}</span>
              </div>
            </dd>
          </div>
        {/for}
      </dl>
    """
  end

  defp rankings(%Team{} = team) do
    [
      {:runs, Statistics.team_ranking(team, :runs)},
      {:runs_allowed, Statistics.team_ranking(team, :runs_allowed)}
    ]
  end
end
