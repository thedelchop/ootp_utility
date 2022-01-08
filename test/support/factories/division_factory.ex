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
      """
      @spec with_divisions(Leagues.League.t() | Leagues.Conference.t(), integer(), map()) ::
              Leagues.League.t() | Leagues.Conference.t()
      def with_divisions(conference_or_league, number_of_divisions \\ 2, attrs \\ %{})

      def with_divisions(
            %Leagues.League{conferences: %Ecto.Association.NotLoaded{}} = league,
            number_of_divisions,
            division_attrs
          ) do
        league
        |> Repo.preload(:conferences)
        |> with_divisions(number_of_divisions, division_attrs)
      end

      def with_divisions(
            %Leagues.League{conferences: []} = league,
            number_of_divisions,
            division_attrs
          ) do
        attrs =
          division_attrs
          |> Map.put(:league, league)
          |> Map.put(:conference, nil)

        %{league | divisions: insert_list(number_of_divisions, :division, attrs)}
      end

      def with_divisions(
            %Leagues.League{conferences: conferences} = league,
            number_of_divisions,
            division_attrs
          ) do
        conferences =
          Enum.map(conferences, &with_divisions(&1, number_of_divisions, division_attrs))

        %{
          league
          | conferences: conferences,
            divisions: Enum.flat_map(conferences, & &1.divisions)
        }
      end

      def with_divisions(
            %Leagues.Conference{league: %Ecto.Association.NotLoaded{}} = conference,
            number_of_divisions,
            division_attrs
          ) do
        conference
        |> Repo.preload(:league)
        |> with_divisions(number_of_divisions, division_attrs)
      end

      def with_divisions(
            %Leagues.Conference{league: league} = conference,
            number_of_divisions,
            division_attrs
          ) do
        attrs =
          division_attrs
          |> Map.put(:league, league)
          |> Map.put(:conference, conference)

        %{conference | divisions: insert_list(number_of_divisions, :division, attrs)}
      end
    end
  end
end
