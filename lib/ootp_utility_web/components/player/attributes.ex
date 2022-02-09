defmodule OOTPUtilityWeb.Components.Player.Attributes do
  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Player.Attributes.Primary, as: PrimaryAttributes
  alias OOTPUtilityWeb.Components.Shared.Section
  alias OOTPUtility.Players

  import OOTPUtility.Players, only: [is_pitcher: 1]

  prop player, :struct, required: true

  def render(assigns) do
    ~F"""
      <Section event_target={@myself}>
        <PrimaryAttributes attributes={attributes(@player)} />
      </Section>
    """
  end

  def handle_event("viewport_resize", _viewport, socket) do
    {:noreply, socket}
  end

  defp attributes(%Players.Player{} = player) when is_pitcher(player) do
    player
    |> Players.Ratings.pitching_ratings_for()
    |> Players.Ratings.grouped_by_attributes()
    |> Players.Ratings.scale_attributes(10)
  end

  defp attributes(%Players.Player{} = player) do
    player
    |> Players.Ratings.batting_ratings_for()
    |> Players.Ratings.grouped_by_attributes()
    |> Players.Ratings.scale_attributes(10)
  end
end
