defmodule OOTPUtility.Games.Game do
  alias OOTPUtility.Leagues.League
  alias OOTPUtility.Players.Player
  alias OOTPUtility.Teams.Team
  alias OOTPUtility.Games.Score

  use OOTPUtility.Schema

  schema "games" do
    field :attendance, :integer
    field :away_team_errors, :integer
    field :away_team_hits, :integer
    field :away_team_runs, :integer
    field :date, :date
    field :dh, :boolean, default: false
    field :game_type, :integer
    field :home_team_errors, :integer
    field :home_team_hits, :integer
    field :home_team_runs, :integer
    field :innings, :integer
    field :played, :boolean, default: false
    field :time, :time

    belongs_to :league, League
    belongs_to :home_team, Team
    belongs_to :away_team, Team

    belongs_to :winning_pitcher, Player
    belongs_to :losing_pitcher, Player

    belongs_to :away_team_starter, Player
    belongs_to :home_team_starter, Player
    belongs_to :save_pitcher, Player

    has_many :scores, Score
  end
end
