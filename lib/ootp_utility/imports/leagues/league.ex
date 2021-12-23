defmodule OOTPUtility.Imports.Leagues.League do
  alias OOTPUtility.Leagues

  import OOTPUtility.Imports.Helpers, only: [convert_league_level: 1]

  use OOTPUtility.Imports,
    from: "leagues",
    headers: [
      {:league_id, :id},
      {:logo_file_name, :logo_filename}
    ],
    schema: Leagues.League,
    slug: :name

  def sanitize_attributes(%{league_level: league_level} = attrs) when is_binary(league_level) do
    sanitize_attributes(%{attrs | league_level: convert_league_level(league_level)})
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
