defmodule OOTPUtilityWeb.Components.Team.Rankings do
  use Surface.Component

  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Statistics

  import OOTPUtilityWeb.Helpers, only: [ordinalize: 1]
  import Phoenix.Naming, only: [humanize: 1]

  prop team, :struct

  def render(assigns) do
    ~F"""
      <div>
        <dl class="grid grid-cols-1 rounded-lg bg-gray overflow-hidden shadow divide-y divide-white-200 md:grid-cols-2 md:divide-y-0 md:divide-x">
          {#for {stat, {rank, total, value}} <- rankings(@team)}
            <div class="px-4 py-5 sm:p-6">
              <dt class="text-base font-normal text-gray-900">
                {humanize(stat)}
              </dt>
              <dd class="mt-1 flex justify-between items-baseline md:block lg:flex">
                <div class="text-2xl font-semibold text-indigo-600">
                  {value}
                </div>
                <div class="mx-1 px-2.5 py-0.5 rounded-full text-sm font-medium bg-green-100 text-green-800 md:mt-2 lg:mt-0">
                  {ordinalize(rank)} of {total}
                </div>
              </dd>
            </div>
          {/for}
        </dl>
      </div>
    """
  end

  defp rankings(%Team{} = team) do
    [
      {:runs, Statistics.team_ranking(team, :runs)},
      {:runs_allowed, Statistics.team_ranking(team, :runs_allowed)}
    ]
  end
end
