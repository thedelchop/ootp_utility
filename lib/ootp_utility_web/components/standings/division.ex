defmodule OOTPUtilityWeb.Components.Standings.Division do
  use Surface.LiveComponent

  alias OOTPUtility.{Leagues, Standings}
  alias OOTPUtilityWeb.Components.Standings.Teams

  prop division, :struct, required: true
  prop compact, :boolean, default: false

  data standings, :struct

  def update(assigns, socket) do
    standings = Standings.for_division(assigns.division)

    {
      :ok,
      socket
      |> assign(:standings, standings)
      |> assign(:division, assigns.division)
      |> assign(:compact, assigns.compact)
    }
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="flex flex-col p-1 lg:p-1 overflow-hidden">
      <Teams
        id={child_id(@division)}
        standings={@standings.team_standings}
        parent_name={name(@division)}
        compact={@compact}
      />
    </div>
    """
  end

  def name(%Leagues.Division{name: name}), do: name

  def child_id(%Leagues.Division{
        conference: %Leagues.Conference{slug: conference_slug},
        league: %Leagues.League{slug: league_slug},
        slug: slug
      }) do
    [league_slug, conference_slug, slug, "teams"]
    |> Enum.join("-")
  end

  def child_id(%Leagues.Division{
        league: %Leagues.League{slug: league_slug},
        slug: slug
      }) do
    [league_slug, slug, "teams"]
    |> Enum.join("-")
  end
end
