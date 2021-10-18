defmodule OOTPUtilityWeb.Components.Standings.League do
  use Surface.LiveComponent

  alias OOTPUtility.{Standings, Leagues}
  alias OOTPUtilityWeb.Components.Standings.{Conference, Division}
  alias Surface.Components.Link
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  prop standings, :struct, required: true

  def child_standings(%Standings.League{conference_standings: [], division_standings: standings}), do: standings
  def child_standings(%Standings.League{conference_standings: standings}), do: standings

  def name(%Standings.League{league: %Leagues.League{name: name}} = _standings), do: name

  def has_conferences?(%Standings.League{conference_standings: []} = _), do: false
  def has_conferences?(_), do: true

  def path_to_league(%Standings.League{league: %Leagues.League{slug: slug}} = _standings, socket) do
    Routes.league_path(socket, :show, slug)
  end
end
