defmodule OOTPUtilityWeb.TeamLiveTest do
  use OOTPUtilityWeb.ConnCase

  import Phoenix.LiveViewTest
  import OOTPUtility.Factory

  setup %{conn: conn} do
    league =
      insert(:league)
      |> with_teams()
      |> with_records()

    team =
      insert(:team,
        league: league,
        conference: nil,
        division: nil,
        name: "Boston",
        nickname: "Red Sox",
        slug: "boston-red-sox"
      )
      |> with_record()
      |> with_roster()

    {:ok, _view, html} = live(conn, "/teams/#{team.slug}")

    {:ok, html: html, team: team}
  end

  test "it includes the name of the team", %{html: html, team: team} do
    assert html =~ "#{team.name} #{team.nickname}"
  end

  test "it includes the team's standings in its division", %{html: html} do
    assert html =~ "2nd in AL East"

    assert html =~ "3rd in American League"
  end
end
