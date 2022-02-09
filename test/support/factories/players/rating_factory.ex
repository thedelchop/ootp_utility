defmodule OOTPUtility.Factories.Players.RatingsFactory do
  alias OOTPUtility.Players
  alias OOTPUtility.Players.Ratings

  defmacro __using__(_opts) do
    quote do
      def batting_ratings_factory do
        %Players.Ratings.Batting{
          id: fn r -> "#{r.player.id}-#{Ecto.Enum.mappings(Ratings.Batting, :type)[r.type]}" end,
          player: build(:player),
          type: Ratings.Pitching |> Ecto.Enum.values(:type) |> Enum.random(),
          contact: Faker.random_between(0, 200),
          gap_power: Faker.random_between(0, 200),
          home_run_power: Faker.random_between(0, 200),
          eye: Faker.random_between(0, 200),
          avoid_strikeouts: Faker.random_between(0, 200)
        }
      end

      def pitching_ratings_factory do
        %Players.Ratings.Pitching{
          id: fn r ->
            "#{r.player.id}-#{Ecto.Enum.mappings(Ratings.Pitching, :type)[r.type]}"
          end,
          player: build(:player),
          type: Ratings.Pitching |> Ecto.Enum.values(:type) |> Enum.random(),
          stuff: Faker.random_between(0, 200),
          control: Faker.random_between(0, 200),
          movement: Faker.random_between(0, 200),
          velocity: Ratings.Pitching |> Ecto.Enum.values(:velocity) |> Enum.random(),
          arm_slot: Ratings.Pitching |> Ecto.Enum.values(:arm_slot) |> Enum.random(),
          stamina: Faker.random_between(0, 200),
          hold_runners: Faker.random_between(0, 200),
          groundball_flyball_ratio: Faker.random_between(1, 5)
        }
      end

      def with_batting_ratings(%Players.Player{} = player, rating_attrs \\ []) do
        for type <- [:ability, :talent, :ability_vs_left, :ability_vs_right] do
          attrs =
            rating_attrs
            |> Keyword.put(:player, player)
            |> Keyword.put(:type, type)

          insert(:batting_ratings, attrs)
        end

        player
      end

      def with_pitching_ratings(%Players.Player{} = player, rating_attrs \\ []) do
        for type <- [:ability, :talent, :ability_vs_left, :ability_vs_right] do
          attrs =
            rating_attrs
            |> Keyword.put(:player, player)
            |> Keyword.put(:type, type)

          insert(:pitching_ratings, attrs)
        end

        player
      end
    end
  end
end
