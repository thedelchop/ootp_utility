defmodule OOTPUtilityWeb.Components.Shared.TableTest do
  use OOTPUtilityWeb.ComponentCase, async: true

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column

  setup do
    assigns = %{
      standings: [
        %{wins: 10, losses: 2, games_behind: 0},
        %{wins: 8, losses: 4, games_behind: 2},
        %{wins: 3, losses: 7, games_behind: 7}
      ]
    }

    {:ok, assigns: assigns}
  end

  test_snapshot "Renders a table with each of the specified columns", %{assigns: assigns} do
    render_surface do
      ~F"""
        <Table id={"test-table"} data={standing <- @standings}>
          <Column label="Wins">
            {standing[:wins]}
          </Column>

          <Column label="Losses">
            {standing[:losses]}
          </Column>

          <Column label="GB">
            {standing[:games_behind]}
          </Column>
        </Table>
      """
    end
  end

  test_snapshot "Provides a `header_class` property to specify header CSS classes", %{
    assigns: assigns
  } do
    header_class = fn _col, _index -> ["text-right", "font-medium", "text-gray-500"] end

    render_surface do
      ~F"""
        <Table id={"test-table"} data={standing <- @standings} header_class={header_class}>
          <Column label="Wins">
            {standing[:wins]}
          </Column>

          <Column label="Losses">
            {standing[:losses]}
          </Column>

          <Column label="GB">
            {standing[:games_behind]}
          </Column>
        </Table>
      """
    end
  end

  test_snapshot "Provides a `row_class` property to specify row CSS classes", %{assigns: assigns} do
    row_class = fn _col, _index -> ["text-right", "font-medium", "text-gray-500"] end

    render_surface do
      ~F"""
        <Table id={"test-table"} data={standing <- @standings} row_class={row_class}>
          <Column label="Wins">
            {standing[:wins]}
          </Column>

          <Column label="Losses">
            {standing[:losses]}
          </Column>

          <Column label="GB">
            {standing[:games_behind]}
          </Column>
        </Table>
      """
    end
  end
end
