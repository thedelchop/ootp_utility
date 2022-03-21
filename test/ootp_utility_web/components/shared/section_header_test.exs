defmodule OOTPUtilityWeb.Components.Shared.SectionHeaderTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Shared.SectionHeader

  test_snapshot "Renders a section header with the specified title" do
    render_surface do
      ~F"""
      <SectionHeader>My Title</SectionHeader>
      """
    end
  end
end
