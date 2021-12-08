defmodule OOTPUtilityWeb.Components.Standings.Conference do
  use Surface.LiveComponent

  alias OOTPUtility.{Standings, Leagues}
  alias OOTPUtilityWeb.ConferenceLive
  alias OOTPUtilityWeb.Components.Standings.{Division, Teams}
  alias Surface.Components.LiveRedirect
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop standings, :struct, required: true

  def render(assigns) do
    ~F"""
      <div class="shadow border-b border-gray-200 rounded-lg">
        <div class="col-span-2 pb-5 border-b border-gray-200">
          <LiveRedirect to={path_to_conference(@standings, @socket)}>
            <h3 class="mt-3 ml-3 text-md leading-6 font-medium text-gray-900">
              {name(@standings)}
            </h3>
          </LiveRedirect>
        </div>
        <div class="grid grid-cols-1 gap-4 lg:gap-8">
          {#for child_standings <- child_standings(@standings)}
            {#if has_divisions?(@standings) }
              <Division id={child_id(@standings, child_standings)} standings={child_standings} />
            {#else}
              <Teams id={child_id(@standings, child_standings)} standings={child_standings} />
            {/if}
          {/for}
        </div>
      </div>
    """
  end

  def child_id(%Standings.Conference{
      conference: %Leagues.Conference{
        league: %Leagues.League{
          slug: league_slug
        },
        slug: slug
      },
    } = _standings, %Standings.Team{} = _team_standings) do

    [league_slug, slug, "teams", "standings"]
    |> Enum.join("-")
  end

  def child_id(%Standings.Conference{
      conference: %Leagues.Conference{
        league: %Leagues.League{
          slug: league_slug
        },
        slug: conference_slug
      }
      } = _standings,
      %Standings.Division{
        division: %Leagues.Division{
          slug: division_slug
        }
      } = _division_standings) do
    [league_slug, conference_slug, division_slug, "standings"]
    |> Enum.join("-")
  end

  def name(%Standings.Conference{conference: %Leagues.Conference{name: name}} = _standings),
    do: name

  def child_standings(%Standings.Conference{
        division_standings: [],
        team_standings: standings
      }),
      do: standings

  def child_standings(%Standings.Conference{division_standings: standings}), do: standings

  def has_divisions?(%Standings.Conference{division_standings: []} = _), do: false
  def has_divisions?(_), do: true

  def path_to_conference(
        %Standings.Conference{
          conference: %Leagues.Conference{
            league: %Leagues.League{
              slug: league_slug
            },
            slug: slug
          }
        } = _standings,
        socket
      ) do
    Routes.live_path(socket, ConferenceLive, league_slug, slug)
  end
end
