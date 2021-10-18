defmodule OOTPUtilityWeb.Components.Standings.Division do
  use Surface.Component

  alias OOTPUtility.{Leagues,Standings}
  alias OOTPUtilityWeb.Components.Standings.Teams
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop standings, :struct, required: true

  def name(%Standings.Division{division: %Leagues.Division{name: name}} = _standings), do: name

  def child_standings(%Standings.Division{team_standings: standings}), do: standings

  def path_to_division(%Standings.Division{division: division} = _standings, socket) do
    Routes.division_path(socket, :show, division.slug)
  end

  @impl true
  def render(assigns) do
    ~F"""
      <div class="flex flex-col">
        <div class="-my-0 lg:-my-2 overflow-x-auto -mx-3 lg:-mx-4">
          <div class="py-0 lg:py-2 align-middle inline-block min-w-full px-3 lg:px-4">
            <div class="overflow-hidden">
              <Teams standings={child_standings(@standings)} parent_path={path_to_division(@standings, @socket)} parent_name={name(@standings)} />
            </div>
          </div>
        </div>
      </div>
    """
  end
end
