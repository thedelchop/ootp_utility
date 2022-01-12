defmodule OOTPUtility.ConferenceFactory do
  alias OOTPUtility.Leagues

  defmacro __using__(_opts) do
    quote do
      def conference_factory do
        %Leagues.Conference{
          id: sequence(:id, &"#{&1}"),
          name: sequence("Test Conference"),
          slug: fn c -> generate_slug_from_name(c) end,
          abbr: "TC",
          designated_hitter: true,
          league: fn -> build(:league) end
        }
      end

      @doc """
        Create the specified number of conferences for the league, using
        the conference attributes passed into the function. By default it will
        create two conferences for the specified league.

        ## Examples
        iex> insert(:league, name: "My League") |> with_conferences()
        %Leagues.League{}

        iex> insert(:league, name: "My League") |> with_conferences([%{name: "American League"}, %{name: "National League"}])
        %Leagues.League{}

        iex> insert(:league, name: "My League") |> with_conferences(%{name: "American League"})
        %Leagues.League{}
      """
      @spec with_conferences(Leagues.League.t(), [map()] | map()) :: Leagues.League.t()
      def with_conferences(league, confereces_attrs \\ [%{}, %{}])

      def with_conferences(%Leagues.League{} = league, []), do: %{league | conferences: []}

      def with_conferences(%Leagues.League{} = league, [%{}, %{}]) do
        %{league | conferences: insert_pair(:conference, league: league)}
      end

      def with_conferences(%Leagues.League{} = league, conference_attrs)
          when is_map(conference_attrs) do
        %{
          league
          | conferences: [insert(:conference, add_league_to_attrs(conference_attrs, league))]
        }
      end

      def with_conferences(%Leagues.League{} = league, conference_attrs) do
        %{
          league
          | conferences:
              Enum.map(conference_attrs, &insert(:conference, add_league_to_attrs(&1, league)))
        }
      end

      defp add_league_to_attrs(conference_attrs, league),
        do: Map.put(conference_attrs, :league, league)
    end
  end
end
