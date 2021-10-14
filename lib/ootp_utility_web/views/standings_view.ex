defmodule OOTPUtilityWeb.StandingsView do
  defmacro __using__(_opts) do
    quote do
      use Phoenix.View,
        root: "lib/ootp_utility_web/templates",
        namespace: OOTPUtilityWeb,
        path: "standings"

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      use Phoenix.HTML
      import Phoenix.View, only: [render: 3, render_many: 4]
      alias OOTPUtilityWeb.Router.Helpers, as: Routes

      alias OOTPUtilityWeb.Standings.{ConferenceView, DivisionView, LeagueView, TeamView}
      alias OOTPUtility.{Leagues, Standings}

      def child_standings(_standings, _conn), do: raw("")
      def link_to_parent(_standings, _conn, _opts), do: raw("")
      def league_container_classes(_standings), do: ""
      def winning_percentage(_team), do: ""
      def streak(_team), do: ""
      def container_name(_standings), do: ""
      def name(_standings), do: ""

      defoverridable child_standings: 2,
        link_to_parent: 3,
        league_container_classes: 1,
        winning_percentage: 1,
        streak: 1,
        name: 1,
        container_name: 1
    end
  end
end
