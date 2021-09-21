defmodule OOTPUtility.Leagues.League do
  @type t() :: %__MODULE__{}

  alias OOTPUtility.{Imports, Schema, Utilities}
  alias OOTPUtility.Leagues.Conference
  alias OOTPUtility.Teams.Team
  alias __MODULE__

  use Schema

  schema "leagues" do
    field :abbr, :string
    field :current_date, :date
    field :league_level, :string
    field :logo_filename, :string
    field :name, :string
    field :season_year, :integer
    field :start_date, :date

    belongs_to :parent_league, League
    has_many :child_leagues, League, foreign_key: :parent_league_id

    has_many :conferences, Conference
    has_many :teams, Team
  end

  use Imports, from: "leagues.csv"

  def sanitize_attributes(
        %{start_date: start_date_as_string, current_date: current_date_as_string} = attrs
      ) do
    with {:ok, start_date} <- Timex.parse(start_date_as_string, "{YYYY}-{M}-{D}"),
         {:ok, current_date} <- Timex.parse(current_date_as_string, "{YYYY}-{M}-{D}") do
      attrs
      |> Utilities.rename_keys([{:league_id, :id}])
      |> Map.put(:start_date, NaiveDateTime.to_date(start_date))
      |> Map.put(:current_date, NaiveDateTime.to_date(current_date))
    end
  end
end
