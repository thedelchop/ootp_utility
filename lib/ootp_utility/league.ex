defmodule OOTPUtility.League do
  use OOTPUtility.Schema

  alias OOTPUtility.Utilities

  use OOTPUtility.Imports,
    attributes: [
      :id,
      :name,
      :abbr,
      :logo_filename,
      :start_date,
      :league_state,
      :season_year,
      :historical_year,
      :league_level,
      :current_date,
      :parent_league_id
    ],
    from: "leagues.csv"

  schema "leagues" do
    field :abbr, :string
    field :current_date, :date
    field :historical_year, :integer
    field :league_level, :string
    field :league_state, :string
    field :logo_filename, :string
    field :name, :string
    field :season_year, :integer
    field :start_date, :date

    belongs_to :parent_league, OOTPUtility.League

    has_many :child_leagues, OOTPUtility.League, foreign_key: :parent_league_id

    has_many :conferences, OOTPUtility.Leagues.Conference

    has_many :divisions, OOTPUtility.Leagues.Division

    has_many :teams, OOTPUtility.Team
  end

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
