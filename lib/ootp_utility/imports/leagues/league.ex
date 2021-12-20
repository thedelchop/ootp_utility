defmodule OOTPUtility.Imports.Leagues.League do
  alias OOTPUtility.Leagues

  use OOTPUtility.Imports,
    from: "leagues",
    headers: [
      {:league_id, :id},
      {:logo_file_name, :logo_filename}
    ],
    schema: Leagues.League,
    slug: :name

  @league_level_mappings %{
    "1" => :major,
    "2" => :triple_a,
    "3" => :double_a,
    "4" => :single_a,
    "5" => :low_a,
    "6" => :rookie,
    "8" => :international,
    "10" => :college,
    "11" => :high_school
  }

  def sanitize_attributes(%{league_level: league_level} = attrs) when is_binary(league_level) do
    sanitize_attributes(%{attrs | league_level: Map.get(@league_level_mappings, league_level)})
  end

  def sanitize_attributes(
        %{start_date: start_date_as_string, current_date: current_date_as_string} = attrs
      ) do
    with {:ok, start_date} <- Timex.parse(start_date_as_string, "{YYYY}-{M}-{D}"),
         {:ok, current_date} <- Timex.parse(current_date_as_string, "{YYYY}-{M}-{D}") do
      attrs
      |> Map.put(:start_date, NaiveDateTime.to_date(start_date))
      |> Map.put(:current_date, NaiveDateTime.to_date(current_date))
    end
  end
end
