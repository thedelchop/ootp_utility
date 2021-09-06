defmodule OOTPUtility.Leagues.League do
  @type t() :: %__MODULE__{}

  use OOTPUtility.Schema

  alias OOTPUtility.Utilities

  use OOTPUtility.Imports,
    attributes: [
      :id,
      :name,
      :abbr,
      :logo_filename,
      :start_date,
      :season_year,
      :league_level,
      :current_date,
      :parent_league_id
    ],
    from: "leagues.csv"

  schema "leagues" do
    field :abbr, :string
    field :current_date, :date
    field :league_level, :string
    field :logo_filename, :string
    field :name, :string
    field :season_year, :integer
    field :start_date, :date

    belongs_to :parent_league, OOTPUtility.Leagues.League
    has_many :child_leagues, OOTPUtility.Leagues.League, foreign_key: :parent_league_id
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
