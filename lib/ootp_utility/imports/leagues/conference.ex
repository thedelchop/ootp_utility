defmodule OOTPUtility.Imports.Leagues.Conference do
  alias OOTPUtility.Leagues

  use OOTPUtility.Imports,
    from: "sub_leagues",
    headers: [{:sub_league_id, :id}],
    schema: Leagues.Conference,
    slug: :name,
    cache: true

  def should_import?(%{name: ""}), do: false
  def should_import?(_), do: true

  def update_changeset(changeset) do
    changeset
    |> Leagues.Conference.put_composite_key()
    |> update_name_and_abberviation()
  end

  defp update_name_and_abberviation(
         %Ecto.Changeset{changes: %{name: name, abbr: abbr, league_id: league_id}} = changeset
       ) do
    if generic_conference_name?(name) do
      %Leagues.League{abbr: league_abbr} = Leagues.get_league!(league_id, preload: [])

      Ecto.Changeset.change(changeset, %{
        name: "#{league_abbr} #{name}",
        abbr: "#{league_abbr}-#{abbr}"
      })
    else
      changeset
    end
  end

  defp generic_conference_name?(name) do
    Regex.match?(~r/Conference\s[1-9]/, name)
  end
end
