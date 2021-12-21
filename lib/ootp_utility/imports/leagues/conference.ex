defmodule OOTPUtility.Imports.Leagues.Conference do
  alias OOTPUtility.Leagues

  use OOTPUtility.Imports,
    from: "sub_leagues",
    headers: [{:sub_league_id, :id}],
    schema: Leagues.Conference,
    slug: :name

  def should_import?(%{name: ""}), do: false
  def should_import?(_), do: true

  def update_changeset(changeset) do
    changeset
    |> Leagues.Conference.put_composite_key()
    |> put_name()
  end

  defp put_name(%Ecto.Changeset{changes: %{name: name, league_id: league_id}} = changeset) do
    %Leagues.League{abbr: league_abbr} = Leagues.get_league!(league_id, preload: [])

    name = if Regex.match?(~r/Conference\s[1-9]/, name), do: "#{league_abbr} #{name}", else: name

    Ecto.Changeset.change(changeset, %{name: name})
  end
end
