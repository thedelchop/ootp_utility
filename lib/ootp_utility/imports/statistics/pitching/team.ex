defmodule OOTPUtility.Imports.Statistics.Pitching.Team do
  defmacro __using__([{:from, filename}, {:schema, schema}]) do
    quote do
      alias OOTPUtility.{Repo, Teams}

      import Ecto.Query, only: [from: 2]

      use OOTPUtility.Imports.Statistics.Pitching,
        from: unquote(filename),
        headers: [
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
        ],
        schema: unquote(schema)

      def sanitize_attributes(attrs) do
        Map.put(attrs, :outs_pitched, calculate_outs_pitched(attrs))
      end

      def update_changeset(changeset) do
        changeset
        |> unquote(schema).put_composite_key()
      end

      def should_import?(%{league_id: "0"} = _attrs), do: false
      def should_import?(_attrs), do: true

      def validate_changeset(
            %Ecto.Changeset{
              changes: %{
                team_id: team_id
              }
            } = _changeset
          ) do
        Repo.exists?(from t in Teams.Team, where: t.id == ^team_id)
      end

      defp calculate_outs_pitched(%{ip: innings_pitched, ipf: innings_pitched_fraction} = _) do
        String.to_integer(innings_pitched) * 3 + String.to_integer(innings_pitched_fraction)
      end
    end
  end
end
