defmodule OOTPUtilityWeb.Components.Team.NameWithLogo do
  use Surface.LiveComponent

  alias Surface.Components.LiveRedirect

  alias OOTPUtilityWeb.Router.Helpers, as: Routes
  alias OOTPUtilityWeb.TeamLive

  prop team, :struct, required: true
  prop class, :css_class, default: []

  def render(assigns) do
    ~F"""
      <LiveRedirect to={path_to_team(@team, @socket)}>
        <div class={container_class(@class)}>
          <div class="flex-shrink-0 h-6 lg:h-10 h-6 lg:w-10">
            <img class="h-6 lg:h-10 w-6 lg:w-10 rounded-full" src={Routes.static_path(@socket, "/images/logos/#{@team.logo_filename}")} alt="">
          </div>
          <div class="ml-3 mt-1.5">
            <div class="lg:hidden text-sm text-left font-medium text-gray-900">
              {@team.abbr}
            </div>
            <div class="hidden lg:block text-lg text-left font-medium text-gray-900">
              {@team.name}
            </div>
          </div>
        </div>
      </LiveRedirect>
    """
  end

  def container_class(extra_classes) do
    ["flex"] ++ extra_classes
  end

  def path_to_team(
        %{
          slug: slug
        } = _team,
        socket
      ) do
    Routes.live_path(socket, TeamLive, slug)
  end
end
