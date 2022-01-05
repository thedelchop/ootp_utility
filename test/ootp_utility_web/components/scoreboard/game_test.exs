defmodule OOTPUtilityWeb.Components.Scoreboard.GameTest do
  use OOTPUtilityWeb.ComponentCase

  alias OOTPUtilityWeb.Components.Scoreboard.Game

  # The default endpoint for testing
  @endpoint OOTPUtilityWeb.Endpoint

  test "returns a summary of a played game" do
    home_team = insert(:team, %{name: "Home Team", abbr: "HT", logo_filename: "home_team.png"})

    winning_pitcher =
      build(:player, %{
        first_name: "Winning",
        last_name: "Pitcher",
        position: "SP",
        team: home_team
      })

    away_team = insert(:team, %{name: "Away Team", abbr: "AT", logo_filename: "away_team.png"})

    losing_pitcher =
      build(:player, %{first_name: "Losing", last_name: "Pitcher", position: "MR", team: away_team})

    save_pitcher =
      build(:player, %{first_name: "Save", last_name: "Pitcher", position: "CL", team: home_team})

    game =
      insert(:completed_game,
        home_team: home_team,
        away_team: away_team,
        home_team_runs: 4,
        away_team_runs: 2,
        winning_pitcher: winning_pitcher,
        losing_pitcher: losing_pitcher,
        save_pitcher: save_pitcher
      )

    html =
      render_surface do
        ~F"""
          <Game id={"#{game.id}-game"} game={game} />
        """
      end

    expected_html =
      """
        <div class="flex">
          <img class="h-5 w-5" src="/images/logos/away_team.png" alt="">
          <h4 class="text-sm tracking-tighter mx-1">AT</h4>
          <h5 class="flex-grow flex-shrink-0 text-xs text-gray-400 text-right ml-2">2</h5>
        </div>
      """
      |> parse_html_for_comparison()

    assert html =~ Regex.compile!(expected_html)
  end

  def parse_html_for_comparison(html) do
    html
    |> String.replace(~r/\n+/, "\n")
    |> String.replace(~r/\n\s+\n/, "\n")
  end
end
