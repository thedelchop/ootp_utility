defmodule OOTPUtility.Imports.Leagues.Division do
  alias OOTPUtility.{Imports, Leagues}

  use OOTPUtility.Imports,
    from: "divisions",
    headers: [{:sub_league_id, :conference_id}, {:division_id, :id}],
    schema: Leagues.Division,
    slug: :name

  def should_import?(%{name: ""}), do: false
  def should_import?(_), do: true

  def update_changeset(changeset) do
    changeset
    |> Leagues.Division.put_composite_key()
    |> put_conference_id()
    |> put_name()
  end

  defp put_name(
         %Ecto.Changeset{changes: %{name: name, league_id: league_id}} =
           changeset
       ) do
    %Leagues.League{abbr: league_abbr} = Leagues.get_league!(league_id, preload: [])

    Ecto.Changeset.change(changeset, %{name: "#{league_abbr} #{get_short_name(name)}"})
  end

  defp put_name(%Ecto.Changeset{changes: %{name: name, conference_id: conference_id}} = changeset) do
    %Leagues.Conference{abbr: conference_abbr} = Leagues.get_conference!(conference_id)

    Ecto.Changeset.change(changeset, %{name: "#{conference_abbr} #{get_short_name(name)}"})
  end

  def get_short_name(name) do
    regex = ~r/(?<short_name>\w+)\sDivision/

    if Regex.match?(regex, name) do
      %{"short_name" => short_name} = Regex.named_captures(regex, name)

      short_name
    else
      name
    end
  end

  defp put_conference_id(%Ecto.Changeset{changes: changes} = changeset) do
    with conference_id <- Leagues.Conference.generate_foreign_key(changes) do
      if Imports.Agent.in_cache?(:conferences, conference_id) do
        Ecto.Changeset.change(changeset, %{conference_id: conference_id})
      else
        Ecto.Changeset.change(changeset, %{conference_id: nil})
      end
    end
  end
end
