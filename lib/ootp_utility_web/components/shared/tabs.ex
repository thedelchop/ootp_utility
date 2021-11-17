defmodule OOTPUtilityWeb.Components.Shared.Tabs do
  @moduledoc """
  A simple horizontal navigation **tabs** component
  """

  use Surface.LiveComponent

  @doc "Make tab full width"
  prop expanded, :boolean, default: false

  @doc "Classic style with borders"
  prop boxed, :boolean, default: false

  @doc "The tabs to display"
  slot tabs, required: true

  data active_tab, :integer, default: 0

  data animation, :string, default: ""

  def update(assigns, socket) do
    first_visible_tab = Enum.find_index(assigns.tabs, & &1.visible)

    socket =
      socket
      |> assign(assigns)
      |> assign(:active_tab, first_visible_tab)

    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <div class={"border-b", "border-gray-200", "is-fullwidth": @expanded}>
      <nav class={"-mb-px", "flex", "space-x-8", "tabs", "is-boxed": @boxed, "is-fullwidth": @expanded} aria-label="Tabs">
        <a
          :for={{tab, index} <- Enum.with_index(@tabs), tab.visible}
          class={"border-transparent", "text-gray-500", "hover:text-gray-700", "hover:border-gray-300", "whitespace-nowrap", "py-4", "px-1", "border-b-2", "font-medium", "text-sm", "is-active": @active_tab == index, isDisabled: tab.disabled}
          :on-click="tab_click"
          phx-value-index={index}
        >
          {tab.label}
        </a>
      </nav>
      <section class="tab-content" style="overflow: hidden;">
        <div
          :for={{tab, index} <- Enum.with_index(@tabs)}
          :show={tab.visible && @active_tab == index}
          class={"tab-item animated #{@animation} faster"}
        >
          <#slot name="tabs" index={index} />
        </div>
      </section>
    </div>
    """
  end

  def handle_event("tab_click", %{"index" => index_str}, socket) do
    index = String.to_integer(index_str)
    animation = next_animation(socket.assigns, index)
    {:noreply, assign(socket, active_tab: index, animation: animation)}
  end

  defp next_animation(assigns, clicked_index) do
    %{animation: animation, active_tab: active_tab} = assigns

    cond do
      clicked_index > active_tab ->
        "slideInRight"

      clicked_index < active_tab ->
        "slideInLeft"

      true ->
        animation
    end
  end
end
