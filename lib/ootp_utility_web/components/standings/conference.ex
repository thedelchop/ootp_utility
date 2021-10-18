defmodule OOTPUtilityWeb.Components.Standings.Conference do
  use Surface.Component

  alias OOTPUtility.{Standings, Leagues}
  alias OOTPUtilityWeb.Components.Standings.{Division, Teams}
  alias Surface.Components.Link
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop standings, :struct, required: true


  def name(%Standings.Conference{conference: %Leagues.Conference{name: name}} = _standings), do: name

  def child_standings(%Standings.Conference{
      division_standings: [],
      team_standings: standings
    }), do: standings

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
      }} = _standings,
         socket
       ) do
    Routes.conference_path(socket, :show, league_slug, slug)
  end
end
