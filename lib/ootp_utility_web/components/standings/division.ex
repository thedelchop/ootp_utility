defmodule OOTPUtilityWeb.Components.Standings.Division do
  use Surface.LiveComponent

  alias OOTPUtility.{Leagues, Standings}
  alias OOTPUtilityWeb.DivisionLive
  alias OOTPUtilityWeb.Components.Standings.Teams
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop standings, :struct, required: true
  prop compact, :boolean, default: false

  @impl true
  def render(assigns) do
    ~F"""
      <div class="flex flex-col overflow-hidden">
        <Teams
          id={child_id(@standings.division)}
          standings={child_standings(@standings)}
          parent_path={path_to_division(@standings.division, @socket)}
          parent_name={name(@standings)}
          {=@compact}
        />
      </div>
    """
  end

  def name(%Standings.Division{division: %Leagues.Division{name: name}} = _standings), do: name

  def child_standings(%Standings.Division{team_standings: standings}), do: standings

  def path_to_division(
    %Leagues.Division{
      conference: %Leagues.Conference{slug: conference_slug},
      league: %Leagues.League{slug: league_slug},
      slug: slug
    },
    socket
  ) do
    Routes.live_path(socket, DivisionLive, league_slug, conference_slug, slug)
  end

  def path_to_division(
    %Leagues.Division{
      league: %Leagues.League{slug: league_slug},
      slug: slug
    },
    socket
  ) do
    Routes.live_path(socket, DivisionLive, league_slug, slug)
  end

  def child_id(
    %Leagues.Division{
      conference: %Leagues.Conference{slug: conference_slug},
      league: %Leagues.League{slug: league_slug},
      slug: slug
    }
  ) do
    [league_slug, conference_slug, slug, "teams"]
    |> Enum.join("-")
  end

  def child_id(
    %Leagues.Division{
      league: %Leagues.League{slug: league_slug},
      slug: slug
    }
  ) do
    [league_slug, slug, "teams"]
    |> Enum.join("-")
  end
end
