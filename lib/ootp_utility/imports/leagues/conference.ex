defmodule OOTPUtility.Imports.Leagues.Conference do
  alias OOTPUtility.Leagues.Conference

  use OOTPUtility.Imports,
    from: "sub_leagues.csv",
    headers: [{:sub_league_id, :id}],
    schema: Conference

  def should_import?(%{name: ""}), do: false
  def should_import?(_), do: true

  def update_changeset(changeset), do: Conference.put_composite_key(changeset)
end
