defmodule OOTPUtilityWeb.Components.Team.NameWithLogo do
  use Surface.LiveComponent

  alias Surface.Components.LiveRedirect

  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  import OOTPUtilityWeb.Helpers.Path, only: [path_to_team: 2]

  prop team, :struct, required: true
  prop class, :css_class, default: []
  prop compact, :boolean, default: false

  def render(assigns) do
    ~F"""
      <LiveRedirect to={path_to_team(@team, @socket)}>
        <div class={container_class(@class)}>
          <div class="flex-shrink-0 h-4 lg:h-8 h-4 lg:w-8">
            <img class="h-4 lg:h-8 w-4 lg:w-8 rounded-full mt-1.5 lg:mt-0" src={Routes.static_path(@socket, "/images/logos/#{@team.logo_filename}")} alt="">
          </div>
          <div class="ml-2 mt-1">
            <div class="lg:hidden">
              {@team.abbr}
            </div>
            <div class="hidden lg:block">
              {team_name_or_abbr(@team, @compact)}
            </div>
          </div>
        </div>
      </LiveRedirect>
    """
  end

  def container_class(extra_classes) do
    ["flex text-sm text-left font-medium text-gray-900"] ++ extra_classes
  end

  def team_name_or_abbr(team, false), do: team.name
  def team_name_or_abbr(team, true), do: team.abbr
end
