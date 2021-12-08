defmodule OOTPUtilityWeb.Components.Standings.Teams do
  use Surface.LiveComponent

  alias OOTPUtilityWeb.Components.Shared.Table
  alias OOTPUtilityWeb.Components.Shared.Table.Column
  alias OOTPUtility.Standings
  alias OOTPUtilityWeb.Router.Helpers, as: Routes

  @default_column_classes [
    "px-3",
    "py-2",
    "lg:px-6",
    "lg:py-4",
    "whitespace-nowrap"
  ]

  @default_header_classes [
    "px-3",
    "py-1",
    "lg:px-6",
    "lg:py-3",
    "text-xs",
    "uppercase",
    "tracking-wider"
  ]

  prop parent_path, :string, default: ""
  prop parent_name, :string, default: ""
  prop standings, :struct

  def render(assigns) do
    ~F"""
      <div>
        <Table id={"#{@id}-table"} data={standing <- @standings} header_class={&header_class/2} column_class={&column_class/2}>
          <Column label={@parent_name}>
            <div class="flex items-center">
              <div class="flex-shrink-0 h-6 lg:h-10 h-6 lg:w-10">
                <img class="h-6 lg:h-10 w-6 lg:w-10 rounded-full" src={Routes.static_path(@socket, "/images/logos/#{standing.logo_filename}")} alt="">
              </div>
              <div class="ml-4">
                <div class="lg:hidden text-sm text-left font-medium text-gray-900">
                  {standing.abbr}
                </div>
                <div class="hidden lg:block text-sm text-left font-medium text-gray-900">
                  {standing.name}
                </div>
              </div>
            </div>
          </Column>

          <Column label="w">
            {standing.wins}
          </Column>

          <Column label="l">
            {standing.losses}
          </Column>

          <Column label="pct">
            {winning_percentage(standing)}
          </Column>

          <Column label="gb">
            {standing.games_behind}
          </Column>

          <Column label="strk">
            {streak(standing)}
          </Column>
        </Table>
      </div>
    """
  end

  def header_class(_col, 0),
    do: do_header_class(["w-1/3", "text-left", "font-bold", "text-gray-900"])

  def header_class(_col, 5),
    do: do_header_class(["text-right", "font-medium", "text-gray-500", "hidden", "lg:table-cell"])

  def header_class(_col, _index),
    do: do_header_class(["text-right", "font-medium", "text-gray-500"])

  def do_header_class(extra_classes \\ []) do
    Enum.join(extra_classes ++ @default_header_classes, " ")
  end

  def column_class(_standing, 0), do: do_column_class()

  def column_class(_standing, 5),
    do: do_column_class(["text-sm", "text-gray-500", "text-right", "hidden", "lg:table-cell"])

  def column_class(_standing, _index),
    do: do_column_class(["text-sm", "text-gray-500", "text-right"])

  defp do_column_class(extra_classes \\ []) do
    Enum.join(extra_classes ++ @default_column_classes, " ")
  end

  def id() do
    Integer.to_string(Enum.random(0..100_000))
  end

  def winning_percentage(%Standings.Team{winning_percentage: pct} = _standing) do
    pct
    |> :erlang.float_to_binary(decimals: 3)
    |> String.trim_leading("0")
  end

  def streak(%Standings.Team{streak: streak} = _standing) when streak > 0, do: "W#{streak}"

  def streak(%Standings.Team{streak: streak} = _standing), do: "L#{abs(streak)}"
end
