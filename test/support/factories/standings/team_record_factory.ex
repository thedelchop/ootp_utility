defmodule OOTPUtility.Standings.TeamRecordFactory do
  alias OOTPUtility.{Leagues, Repo, Standings, Teams}

  defmacro __using__(_opts) do
    quote do
      def team_record_factory(attrs) do
        games = Map.get_lazy(attrs, :games, fn -> Faker.random_between(1, 162) end)
        wins = Map.get_lazy(attrs, :wins, fn -> Faker.random_between(1, games) end)

        %Standings.TeamRecord{
          id: sequence(:id, &"#{&1}"),
          games: games,
          games_behind: 3.0,
          losses: games - wins,
          magic_number: 1,
          position: 1,
          streak: 3,
          winning_percentage: wins / games,
          wins: wins,
          team: fn -> build(:team) end
        }
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end

      def with_records(parent, games_played_per_team \\ 5)

      def with_records(
            %Leagues.League{conferences: %Ecto.Association.NotLoaded{}} = league,
            games_played_per_team
          ) do
        league
        |> preload_records_associations()
        |> with_records(games_played_per_team)
      end

      def with_records(
            %Leagues.League{divisions: %Ecto.Association.NotLoaded{}} = league,
            games_played_per_team
          ) do
        league
        |> preload_records_associations()
        |> with_records(games_played_per_team)
      end

      def with_records(
            %Leagues.League{teams: %Ecto.Association.NotLoaded{}} = league,
            games_played_per_team
          ) do
        league
        |> preload_records_associations()
        |> with_records(games_played_per_team)
      end

      def with_records(
            %Leagues.League{conferences: [], divisions: [], teams: teams} = league,
            games_played_per_team
          ) do
        team_win_totals =
          teams
          |> Enum.count()
          |> distribute_wins_amongst_teams(games_played_per_team)

        teams
        |> Enum.zip(team_win_totals)
        |> Enum.each(fn
          {team, wins} ->
            insert(:team_record, team: team, games: games_played_per_team, wins: wins)
        end)

        Repo.preload(league, teams: [:record])
      end

      def with_records(
            %Leagues.League{conferences: [], divisions: divisions} = league,
            games_played_per_team
          ) do
        Enum.each(divisions, &with_records(&1, games_played_per_team))

        Repo.preload(league, divisions: [teams: [:record]])
      end

      def with_records(%Leagues.League{conferences: conferences} = league, games_played_per_team) do
        Enum.each(conferences, &with_records(&1, games_played_per_team))

        Repo.preload(league, conferences: [divisions: [teams: [:record]]])
      end

      def with_records(
            %Leagues.Conference{divisions: %Ecto.Association.NotLoaded{}} = conference,
            games_played_per_team
          ) do
        conference
        |> preload_records_associations()
        |> with_records(games_played_per_team)
      end

      def with_records(
            %Leagues.Conference{teams: %Ecto.Association.NotLoaded{}} = conference,
            games_played_per_team
          ) do
        conference
        |> preload_records_associations()
        |> with_records(games_played_per_team)
      end

      def with_records(
            %Leagues.Conference{divisions: [], teams: teams} = conference,
            games_played_per_team
          ) do
        team_win_totals =
          teams
          |> Enum.count()
          |> distribute_wins_amongst_teams(games_played_per_team)

        teams
        |> Enum.zip(team_win_totals)
        |> Enum.each(fn
          {team, wins} ->
            insert(:team_record, team: team, games: games_played_per_team, wins: wins)
        end)

        Repo.preload(conference, teams: [:record])
      end

      def with_records(
            %Leagues.Conference{divisions: divisions} = conference,
            games_played_per_team
          ) do
        Enum.each(divisions, &with_records(&1, games_played_per_team))

        Repo.preload(conference, divisions: [teams: [:record]])
      end

      def with_records(
            %Leagues.Division{teams: %Ecto.Association.NotLoaded{}} = division,
            games_played_per_team
          ) do
        division
        |> preload_records_associations()
        |> with_records(games_played_per_team)
      end

      def with_records(%Leagues.Division{teams: teams} = division, games_played_per_team) do
        team_win_totals =
          teams
          |> Enum.count()
          |> distribute_wins_amongst_teams(games_played_per_team)

        teams
        |> Enum.zip(team_win_totals)
        |> Enum.each(fn
          {team, wins} ->
            insert(:team_record, team: team, games: games_played_per_team, wins: wins)
        end)

        Repo.preload(division, :teams)
      end

      def with_record(%Teams.Team{} = team, attrs) do
        insert(:team_record, Map.put(attrs, :team, team))

        Repo.preload(team, :record)
      end

      defp preload_records_associations(%Leagues.League{} = league) do
        Repo.preload(league, [
          :teams,
          conferences: [:teams, divisions: [:teams]],
          divisions: [:teams]
        ])
      end

      defp preload_records_associations(%Leagues.Conference{} = conference) do
        conference
        |> Repo.preload(:teams, division: [:teams])
      end

      defp preload_records_associations(%Leagues.Division{} = division) do
        division
        |> Repo.preload(:teams)
      end
    end
  end
end
