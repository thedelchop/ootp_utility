defmodule OOTPUtility.Imports.Leagues.Conference do
  alias OOTPUtility.Leagues

  use OOTPUtility.Imports,
    from: "sub_leagues",
    headers: [{:sub_league_id, :id}],
    schema: Leagues.Conference,
    slug: :name

  def should_import?(%{name: ""}), do: false
  def should_import?(_), do: true

  def update_changeset(changeset), do: Leagues.Conference.put_composite_key(changeset)
end
