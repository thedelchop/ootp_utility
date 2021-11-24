defmodule OOTPUtilityWeb.Components.Shared.Tabs do
  @moduledoc """
  A simple horizontal navigation **tabs** component
  """
  use Surface.LiveComponent

  @doc "The tabs to display"
  slot tabs, required: true

  data active_tab, :integer, default: 0

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
    <div>
      <div class={"border-b", "border-gray-200"}>
        <nav class={"-mb-px", "flex", "space-x-8"} aria-label="Tabs">
          {#for {tab, index} <- Enum.with_index(@tabs)}
            <a
              :show={tab.visible}
              :on-click="tab_click"
              phx-value-index={index}
              class={tab_css_classes(index, @active_tab)}
            >
              {tab.label}
            </a>
          {/for}
        </nav>
      </div>
      <section class="overflow-hidden">
        {#for {tab, index} <- Enum.with_index(@tabs)}
          <div
            :show={tab.visible && @active_tab == index}
          >
            <#slot name="tabs" index={index} />
        </div>
        {/for}
      </section>
    </div>
    """
  end

  def tab_css_classes(current_tab_index, active_tab) when active_tab == current_tab_index do
    ~w(border-indigo-500 text-indigo-600)s ++ default_tab_css_classes()
  end

  def tab_css_classes(_current_tab_index, _active_tab) do
    ~w(border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300)s ++
      default_tab_css_classes()
  end

  def default_tab_css_classes() do
    ~w(group inline-flex items-center py-3 px-1 border-b-2 font-medium text-sm cursor-pointer)s
  end

  def handle_event("tab_click", %{"index" => index_str}, socket) do
    index = String.to_integer(index_str)
    {:noreply, assign(socket, active_tab: index)}
  end
end
