defmodule OOTPUtilityWeb.Components.Standings.TeamsTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Standings.Teams, as: TeamsStandings

  setup do
    standings = [
      build(:team_standings,
        name: "Boston Red Sox",
        abbr: "BOS",
        logo_filename: "boston_red_sox.png",
        games: 100,
        wins: 61,
        games_behind: 0,
        streak: 5
      ),
      build(:team_standings,
        name: "New York Yankees",
        abbr: "NYY",
        logo_filename: "new_york_yankees.png",
        games: 100,
        wins: 55,
        games_behind: 6.0,
        streak: 2
      ),
      build(:team_standings,
        name: "Toronto Blue Jays",
        abbr: "TOR",
        logo_filename: "toronto_blue_jays.png",
        games: 100,
        wins: 50,
        games_behind: 11.0,
        streak: -2
      )
    ]

    {:ok, standings: standings, conn: Phoenix.ConnTest.build_conn()}
  end

  test_snapshot "renders a list in the standings table for each team standings", %{
    conn: conn,
    standings: standings
  } do
    assigns = %{socket: conn}

    render_surface do
      ~F"""
      <TeamsStandings id="team-standings" standings={standings} />
      """
    end
  end

  test_snapshot "accepts a name its parent", %{standings: standings, conn: conn} do
    assigns = %{socket: conn}

    render_surface do
      ~F"""
      <TeamsStandings id="team-standings" standings={standings} parent_name="American League" />
      """
    end
  end

  test_snapshot "it provides a compact property to condense the table", %{
    standings: standings,
    conn: conn
  } do
    assigns = %{socket: conn}

    render_surface do
      ~F"""
      <TeamsStandings id="team-standings" standings={standings} compact />
      """
    end
  end
end
