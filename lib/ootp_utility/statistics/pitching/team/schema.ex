defmodule OOTPUtility.Statistics.Pitching.Team.Schema do
  alias OOTPUtility.{Repo, Teams, Utilities}
  defmacro __using__([{:from, filename}, {:to, source}]) do
    quote do
      import OOTPUtility.Statistics.Pitching.Team.Schema

      use OOTPUtility.Statistics.Pitching.Schema,
        from: unquote(filename),
        composite_key: [:team_id, :year],
        foreign_key: [:id, :year]

      import Ecto.Query, only: [from: 2]

      pitching_schema unquote(source) do
        field :fielding_independent_pitching, :float
      end

      def sanitize_pitching_attributes(attrs),
        do:
          OOTPUtility.Statistics.Pitching.Team.Schema.sanitize_pitching_attributes(__MODULE__, attrs)

      def valid_for_import?(%{league_id: "0"} = _attrs), do: false

      def valid_for_import?(%{team_id: team_id} = _attrs) do
        Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
      end
    end
  end

  def sanitize_pitching_attributes(_module, attrs) do
    attrs
    |> Map.put(:outs_pitched, calculate_outs_pitched(attrs))
    |> rename_keys()
  end

  defp rename_keys(attrs),
    do:
      Utilities.rename_keys(attrs, [
        {:avg, :batting_average},
        {:babip, :batting_average_on_balls_in_play},
        {:bb9, :walks_per_9},
        {:bsvp, :blown_save_percentage},
        {:cgp, :complete_game_percentage},
        {:era, :earned_run_average},
        {:fip, :fielding_independent_pitching},
        {:gbfbp, :ground_ball_percentage},
        {:gfp, :games_finished_percentage},
        {:h9, :hits_per_9},
        {:hr9, :home_runs_per_9},
        {:k9, :strikeouts_per_9},
        {:kbb, :strikeouts_to_walks_ratio},
        {:obp, :on_base_percentage},
        {:ops, :on_base_plus_slugging},
        {:pig, :pitches_per_game},
        {:qsp, :quality_start_percentage},
        {:r9, :runs_per_9},
        {:rsg, :run_support_per_start},
        {:slg, :slugging},
        {:svp, :save_percentage},
        {:whip, :walks_hits_per_inning_pitched},
        {:winp, :winning_percentage}
      ])

  defp calculate_outs_pitched(%{ip: innings_pitched, ipf: innings_pitched_fraction} = _) do
    String.to_integer(innings_pitched) * 3 + String.to_integer(innings_pitched_fraction)
  end
end
