defmodule OOTPUtility.Teams.Affiliation do
  alias OOTPUtility.Teams.Team

  use OOTPUtility.Schema,
    composite_key: [:team_id, :affiliate_id]

  schema "team_affiliations" do
    belongs_to :team, Team
    belongs_to :affiliate, Team
  end
end
