defmodule OOTPUtilityWeb.Components.Shared.TabsTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Shared.Tabs
  alias OOTPUtilityWeb.Components.Shared.Tabs.Tab

  test_snapshot "Renders a set of tabs with custom content" do
    render_surface do
      ~F"""
        <Tabs id="test-tabs">
          <Tab label="Tab 1">
            <h1>This is my first tab</h1>
          </Tab>
          <Tab label="Tab 2">
            <h1>This is my second tab</h1>
          </Tab>
        </Tabs>
      """
    end
  end

  test_snapshot "Accepts a class property to style the container" do
    render_surface do
      ~F"""
        <Tabs id="test-tabs" class={["mb-5", "p-2"]}>
          <Tab label="Tab 1">
            <h1>This is my first tab</h1>
          </Tab>
          <Tab label="Tab 2">
            <h1>This is my second tab</h1>
          </Tab>
        </Tabs>
      """
    end
  end
end
