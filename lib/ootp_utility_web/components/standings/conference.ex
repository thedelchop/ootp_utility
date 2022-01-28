defmodule OOTPUtilityWeb.Components.Standings.Conference do
  use Surface.LiveComponent

  alias OOTPUtility.{Standings, Leagues}
  alias OOTPUtilityWeb.ConferenceLive
  alias OOTPUtilityWeb.Components.Standings.{Division, Teams}
  alias Surface.Components.LiveRedirect
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop conference, :struct, required: true
  data standings, :struct

  def update(assigns, socket) do
    standings = Standings.for_conference(assigns.conference)

    {
      :ok,
      socket
      |> assign(:standings, standings)
      |> assign(:conference, assigns.conference)
    }
  end

  def render(assigns) do
    ~F"""
      <div class="shadow border-b border-gray-200 rounded-lg">
        <div class="col-span-2 pb-4 border-b border-gray-200">
          <LiveRedirect to={path_to_conference(@conference, @socket)}>
            <h3 class="mt-2 ml-2 text-md font-medium text-gray-900">
              {name(@conference)}
            </h3>
          </LiveRedirect>
        </div>
        <div class="grid grid-cols-1 gap-4 lg:gap-8">
          {#if has_divisions?(@conference)}
            {#for division <- @conference.divisions}
              <Division id={child_id(@conference, division)} division={division} />
            {/for}
          {#else}
            <Teams id={child_id(@conference, @standings.team_standings)} standings={@standings.team_standings} />
          {/if}
        </div>
      </div>
    """
  end

  def child_id(
        %Leagues.Conference{
          league: %Leagues.League{
            slug: league_slug
          },
          slug: conference_slug
        },
        %Leagues.Division{
          slug: division_slug
        }
      ) do
    [league_slug, conference_slug, division_slug, "standings"]
    |> Enum.join("-")
  end

  def child_id(
        %Leagues.Conference{
          league: %Leagues.League{
            slug: league_slug
          },
          slug: slug
        },
        _team_standings
      ) do
    [league_slug, slug, "teams", "standings"]
    |> Enum.join("-")
  end

  def name(%Leagues.Conference{name: name}), do: name

  def has_divisions?(%Leagues.Conference{divisions: []}), do: false
  def has_divisions?(_), do: true

  def path_to_conference(
        %Leagues.Conference{
          league: %Leagues.League{
            slug: league_slug
          },
          slug: slug
        },
        socket
      ) do
    Routes.live_path(socket, ConferenceLive, league_slug, slug)
  end
end
