defmodule OOTPUtilityWeb.Helpers.Path do
  alias OOTPUtility.{Leagues, Standings, Teams}
  alias OOTPUtilityWeb.Router.Helpers, as: Routes
  alias OOTPUtilityWeb.{ConferenceLive, DivisionLive, LeagueLive, TeamLive}

  def path_to_team_logo(socket, team) do
    Routes.static_path(socket, "/images/logos/#{team.logo_filename}")
  end

  def path_to_team(%Teams.Team{slug: slug} = _team, socket), do: do_path_to_team(slug, socket)
  def path_to_team(%Standings.Team{slug: slug} = _ts, socket), do: do_path_to_team(slug, socket)

  defp do_path_to_team(slug, socket), do: Routes.live_path(socket, TeamLive, slug)

  def path_to_league(%Leagues.League{slug: slug}, socket) do
    Routes.live_path(socket, LeagueLive, slug)
  end

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

  def path_to_division(
        %Leagues.Division{
          conference: nil,
          league: %Leagues.League{slug: league_slug},
          slug: slug
        },
        socket
      ) do
    Routes.live_path(socket, DivisionLive, league_slug, slug)
  end

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
end
