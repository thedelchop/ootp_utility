defmodule OOTPUtility.DivisionFactory do
  alias OOTPUtility.{Leagues, Repo}
  import OOTPUtility.Factories.Utilities, only: [generate_slug_from_name: 1]

  defmacro __using__(_opts) do
    quote do
      def division_factory(attrs) do
        league = Map.get_lazy(attrs, :league, fn -> insert(:league) end)

        conference =
          Map.get_lazy(attrs, :conference, fn -> build(:conference, league: league) end)

        division = %Leagues.Division{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Division"),
          slug: fn d -> generate_slug_from_name(d) end,
          league: league,
          conference: conference
        }

        division
        |> merge_attributes(Map.delete(attrs, [:league, :conference]))
        |> evaluate_lazy_attributes()
      end

      @doc """
        Create the specified number of divisions for the league or conference,
        using the division attributes passed into the function.

        iex> insert(:league) |> with_divisions()
        %Leagues.League{}

        iex> insert(:conference) |> with_divisions()
        %Leagues.Conference{}

        iex> insert(:league, name: "My League") |> with_divisions([%{name: "East Division"}, %{name: "West Divisions"}])
        %Leagues.League{}
      """
      @spec with_divisions(Leagues.League.t() | Leagues.Conference.t(), [map()] | map()) ::
              Leagues.League.t() | Leagues.Conference.t()
      def with_divisions(conference_or_league, divisions_attrs \\ [%{}, %{}])

      def with_divisions(conference_or_league, []), do: %{conference_or_league | divisions: []}

      def with_divisions(
            %Leagues.League{conferences: %Ecto.Association.NotLoaded{}} = league,
            divisions_attrs
          ) do
        league
        |> Repo.preload(:conferences)
        |> with_divisions(divisions_attrs)
      end

      def with_divisions(%Leagues.League{conferences: []} = league, []) do
        %{league | divisions: []}
      end

      def with_divisions(%Leagues.League{conferences: []} = league, [%{}, %{}]) do
        %{league | divisions: insert_pair(:division, league: league, conference: nil)}
      end

      def with_divisions(
            %Leagues.League{conferences: []} = league,
            divisions_attrs
          ) do
        divisions =
          Enum.map(
            divisions_attrs,
            &insert(:division, Map.merge(&1, %{league: league, conference: nil}))
          )

        %{league | divisions: divisions}
      end

      def with_divisions(
            %Leagues.League{conferences: conferences} = league,
            divisions_attrs
          ) do
        conferences = Enum.map(conferences, &with_divisions(&1, divisions_attrs))

        %{
          league
          | conferences: conferences,
            divisions: Enum.flat_map(conferences, & &1.divisions)
        }
      end

      def with_divisions(
            %Leagues.Conference{league: %Ecto.Association.NotLoaded{}} = conference,
            divisions_attrs
          ) do
        conference
        |> Repo.preload(:league)
        |> with_divisions(divisions_attrs)
      end

      def with_divisions(%Leagues.Conference{league: league} = conference, []) do
        %{conference | divisions: []}
      end

      def with_divisions(%Leagues.Conference{league: league} = conference, [%{}, %{}]) do
        %{conference | divisions: insert_pair(:division, league: league, conference: conference)}
      end

      def with_divisions(
            %Leagues.Conference{league: league} = conference,
            divisions_attrs
          ) do
        divisions =
          Enum.map(
            divisions_attrs,
            &insert(:division, Map.merge(&1, %{league: league, conference: conference}))
          )

        %{conference | divisions: divisions}
      end
    end
  end
end
