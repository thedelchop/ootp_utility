defmodule OOTPUtilityWeb.Components.Shared.Icons.Star do
  use Surface.Component

  prop class, :css_class, default: []
  prop half_star, :boolean, default: false
  prop type, :atom, values: [:ability, :talent, :transition], default: :ability

  def render(assigns) do
    ~F"""
    <svg xmlns="http://www.w3.org/2000/svg" class={svg_css_class(@class, @type)} viewBox="0 0 20 20">
      <path
        fill={path_fill(@half_star, @type)}
        d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
      />
    </svg>
    """
  end

  def path_fill(true, :ability), do: "url('#abilityGradient')"
  def path_fill(true, :transition), do: "url('#abilityToTalentGradient')"
  def path_fill(true, :talent), do: "url('#talentGradient')"
  def path_fill(false, _), do: ""

  def fill_color(:talent), do: "fill-zinc-400"
  def fill_color(_), do: "fill-yellow-400"

  def svg_css_class(extra_classes, type) do
    ["h-6", "sm:h-10", "w-6", "sm:w-10", fill_color(type)] ++ extra_classes
  end
end
