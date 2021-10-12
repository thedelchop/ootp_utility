defmodule OOTPUtility.Imports.Leagues.League do
  use OOTPUtility.Imports,
    from: "leagues.csv",
    headers: [
      {:league_id, :id},
      {:logo_file_name, :logo_filename}
    ],
    schema: OOTPUtility.Leagues.League,
    slug: :name

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
