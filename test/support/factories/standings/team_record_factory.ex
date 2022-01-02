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

      @doc """
      Adds records to the parent's set of teams whether that be a League, Conference, Division or
      Team.

      ## Parameters

      parent - A League, Conference or Division to which the teams will be added
      attrs - Attributes for the TeamRecords being created.

      """
      @spec with_records(Leagues.t() | Teams.Team.t(), map()) :: Leagues.t() | Teams.Team.t()
      def with_records(parent, record_attributes \\ %{})

      def with_records(
            %Leagues.League{conferences: %Ecto.Association.NotLoaded{}} = league,
            record_attributes
          ) do
        league
        |> preload_records_associations()
        |> with_records(record_attributes)
      end

      def with_records(
            %Leagues.League{divisions: %Ecto.Association.NotLoaded{}} = league,
            record_attributes
          ) do
        league
        |> preload_records_associations()
        |> with_records(record_attributes)
      end

      def with_records(
            %Leagues.League{teams: %Ecto.Association.NotLoaded{}} = league,
            record_attributes
          ) do
        league
        |> preload_records_associations()
        |> with_records(record_attributes)
      end

      def with_records(
            %Leagues.League{conferences: [], divisions: [], teams: teams} = league,
            record_attributes
          ) do
        games_played_per_team = Map.get(record_attributes, :games, 5)

        team_win_totals =
          teams
          |> Enum.count()
          |> distribute_wins_amongst_teams(games_played_per_team)

        teams
        |> Enum.zip(team_win_totals)
        |> Enum.each(fn
          {team, wins} ->
            attrs =
              record_attributes
              |> Map.put(:team, team)
              |> Map.put(:games, games_played_per_team)
              |> Map.put(:wins, wins)

            insert(:team_record, attrs)
        end)

        Repo.preload(league, teams: [:record])
      end

      def with_records(
            %Leagues.League{conferences: [], divisions: divisions} = league,
            record_attributes
          ) do
        Enum.each(divisions, &with_records(&1, record_attributes))

        Repo.preload(league, divisions: [teams: [:record]])
      end

      def with_records(%Leagues.League{conferences: conferences} = league, record_attributes) do
        Enum.each(conferences, &with_records(&1, record_attributes))

        Repo.preload(league, conferences: [divisions: [teams: [:record]]])
      end

      def with_records(
            %Leagues.Conference{divisions: %Ecto.Association.NotLoaded{}} = conference,
            record_attributes
          ) do
        conference
        |> preload_records_associations()
        |> with_records(record_attributes)
      end

      def with_records(
            %Leagues.Conference{teams: %Ecto.Association.NotLoaded{}} = conference,
            record_attributes
          ) do
        conference
        |> preload_records_associations()
        |> with_records(record_attributes)
      end

      def with_records(
            %Leagues.Conference{divisions: [], teams: teams} = conference,
            record_attributes
          ) do
        games_played_per_team = Map.get(record_attributes, :games, 5)

        team_win_totals =
          teams
          |> Enum.count()
          |> distribute_wins_amongst_teams(games_played_per_team)

        teams
        |> Enum.zip(team_win_totals)
        |> Enum.each(fn
          {team, wins} ->
            attrs =
              record_attributes
              |> Map.put(:team, team)
              |> Map.put(:games, games_played_per_team)
              |> Map.put(:wins, wins)

            insert(:team_record, attrs)
        end)

        Repo.preload(conference, teams: [:record])
      end

      def with_records(
            %Leagues.Conference{divisions: divisions} = conference,
            record_attributes
          ) do
        Enum.each(divisions, &with_records(&1, record_attributes))

        Repo.preload(conference, divisions: [teams: [:record]])
      end

      def with_records(
            %Leagues.Division{teams: %Ecto.Association.NotLoaded{}} = division,
            record_attributes
          ) do
        division
        |> preload_records_associations()
        |> with_records(record_attributes)
      end

      def with_records(%Leagues.Division{teams: teams} = division, record_attributes) do
        games_played_per_team = Map.get(record_attributes, :games, 5)

        team_win_totals =
          teams
          |> Enum.count()
          |> distribute_wins_amongst_teams(games_played_per_team)

        teams
        |> Enum.zip(team_win_totals)
        |> Enum.each(fn
          {team, wins} ->
            attrs =
              record_attributes
              |> Map.put(:team, team)
              |> Map.put(:games, games_played_per_team)
              |> Map.put(:wins, wins)

            insert(:team_record, attrs)
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
