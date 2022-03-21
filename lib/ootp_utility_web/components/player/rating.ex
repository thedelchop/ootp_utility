defmodule OOTPUtilityWeb.Components.Player.Rating do
  @moduledoc """
  A component to render a Player's ability and talent ratings
  as a set of stars
  """
  use Surface.Component

  alias OOTPUtility.Players
  alias OOTPUtilityWeb.Components.Shared.Icons.Star

  import OOTPUtilityWeb.Helpers, only: [player_rating_as_stars: 1]

  prop player, :struct
  prop class, :css_class, default: []

  def render(assigns) do
    ~F"""
    <svg style="width:0;height:0;position:absolute;" aria-hidden="true" focusable="false">
      <defs>
        <linearGradient id="abilityGradient">
          <stop offset="55%" stop-color="rgb(250, 204, 21)" />
          <stop offset="45%" stop-color="rgb(249, 250, 251)" />
        </linearGradient>

        <linearGradient id="abilityToTalentGradient">
          <stop offset="55%" stop-color="rgb(250, 204, 21)" />
          <stop offset="45%" stop-color="rgb(161, 161, 170)" />
        </linearGradient>

        <linearGradient id="talentGradient">
          <stop offset="55%" stop-color="rgb(161, 161, 170)" />
          <stop offset="45%" stop-color="rgb(249, 250, 251)" />
        </linearGradient>
      </defs>
    </svg>

    <ul class={rating_css_class(@class)}>
      {#for _star <- 1..floor(ability_stars(@player))}
        <li><Star /></li>
      {/for}

      {#if talent_stars(@player) > ability_stars(@player)}
        {#if ability_stars(@player) - floor(ability_stars(@player)) > 0}
          <li><Star half_star type={:transition} /></li>
        {/if}

        {#for _star <- 1..floor(talent_stars(@player) - ability_stars(@player))}
          <li><Star type={:talent} /></li>
        {/for}

        {#if talent_stars(@player) - floor(talent_stars(@player)) > 0}
          <li><Star half_star type={:talent} /></li>
        {/if}
      {#else}
        {#if ability_stars(@player) - floor(ability_stars(@player)) > 0}
          <li><Star half_star /></li>
        {/if}
      {/if}
    </ul>
    """
  end

  def rating_css_class(extra_classes) do
    [
      "flex",
      "bg-gray-50",
      "shadow",
      "p-2",
      "md:p-4",
      "rounded-lg"
    ] ++ extra_classes
  end

  defp ability_stars(%Players.Player{ability: ability}), do: player_rating_as_stars(ability)

  defp talent_stars(%Players.Player{talent: talent}), do: player_rating_as_stars(talent)
end
