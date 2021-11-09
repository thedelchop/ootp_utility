defmodule OOTPUtilityWeb.Components.Standings.Division do
  use Surface.LiveComponent

  alias OOTPUtility.{Leagues, Standings}
  alias OOTPUtilityWeb.DivisionLive
  alias OOTPUtilityWeb.Components.Standings.Teams
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop standings, :struct, required: true

  def name(%Standings.Division{division: %Leagues.Division{name: name}} = _standings), do: name

  def child_standings(%Standings.Division{team_standings: standings}), do: standings

  def path_to_division(
        %Leagues.Division{
          conference: nil,
          league: %Leagues.League{slug: league_slug},
          slug: slug
        } = _division,
        socket
      ) do
    Routes.live_path(socket, DivisionLive, %{league_slug: league_slug, slug: slug})
  end

  def path_to_division(
        %Standings.Division{
          division: %Leagues.Division{
            conference: %Leagues.Conference{slug: conference_slug},
            league: %Leagues.League{slug: league_slug},
            slug: slug
          }
        } = _standings,
        socket
      ) do
    Routes.live_path(socket, DivisionLive, %{
      league_slug: league_slug,
      conference_slug: conference_slug,
      slug: slug
    })
  end

  @impl true
  def render(assigns) do
    ~F"""
      <div class="flex flex-col">
        <div class="-my-0 lg:-my-2 overflow-x-auto -mx-3 lg:-mx-4">
          <div class="py-0 lg:py-2 align-middle inline-block min-w-full px-3 lg:px-4">
            <div class="overflow-hidden">
              <Teams id="#{@standings.id}-teams" standings={child_standings(@standings)} parent_path={path_to_division(@standings, @socket)} parent_name={name(@standings)} />
            </div>
          </div>
        </div>
      </div>
    """
  end
end
