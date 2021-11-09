defmodule OOTPUtilityWeb.Components.Team.Rankings do
  use Surface.Component

  prop rankings, :list
  prop team, :struct

  def render(assigns) do
    ~F"""
      <div id="team-rankings" class="flex-initial">
        <h3 class="text-lg text-center leading-6 font-medium text-gray-900">
          Team Stats
        </h3>
        <dl class="mt-5 grid grid-cols-1 rounded-lg bg-white overflow-hidden shadow divide-y divide-gray-200 md:grid-cols-3 md:divide-y-0 md:divide-x">
          {#for ranking <- @rankings}
            <div class="px-4 py-5 sm:p-6">
              <dt class="text-base font-normal text-gray-900">
                {ranking.name}
              </dt>
              <dd class="mt-1 flex justify-between items-baseline md:block lg:flex">
                <div class="text-2xl font-semibold text-indigo-600">
                  {ranking.value}
                </div>
                <div class="px-2.5 py-0.5 rounded-full text-sm font-medium bg-green-100 text-green-800 md:mt-2 lg:mt-0">
                  {rank_in(ranking)}
                </div>
              </dd>
            </div>
          {/for}
        </dl>
      </div>
    """
  end

  defp rank_in(_ranking) do
    "3rd in AL"
  end
end
