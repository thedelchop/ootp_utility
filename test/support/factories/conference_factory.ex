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
        the conference attributes passed into the function.

        iex> insert(:league, name: "My League") |> with_conferences()
        %Leagues.League{}

        iex> insert(:league, name: "My League") |> with_conferences(%{division: nil})
        %Leagues.League{}
      """
      @spec with_conferences(Leagues.League.t(), integer(), map()) :: Leagues.League.t()
      def with_conferences(
            %Leagues.League{} = league,
            number_of_conferences \\ 2,
            conference_attrs \\ Map.new()
          ) do
        conference_attributes = conference_attrs |> Map.put(:league, league)

        %{
          league
          | conferences: insert_list(number_of_conferences, :conference, conference_attributes)
        }
      end
    end
  end
end
