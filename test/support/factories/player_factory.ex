defmodule OOTPUtility.PlayerFactory do
  alias OOTPUtility.Players.Player
  alias OOTPUtility.Utilities

  defmacro __using__(_opts) do
    quote do
      def player_factory(attrs) do
        position_or_key =
          Map.get_lazy(attrs, :position, fn ->
            1..13 |> Enum.random() |> Utilities.position_from_scoring_key()
          end)

        if position_or_key in Utilities.position_keys() do
          position = Utilities.expand_position_key(position_or_key)

          player_factory(%{attrs | position: position})
        else
          %Player{
            id: sequence(:id, &"#{&1}"),
            first_name: Faker.Person.first_name(),
            last_name: Faker.Person.last_name(),
            slug: fn p -> Slug.slugify("#{p.first_name}-#{p.last_name}") end,
            weight: Enum.random(140..275),
            height: Enum.random(170..215),
            bats: Enum.random(["right", "left", "switch"]),
            throws: Enum.random(["right", "left"]),
            age: Enum.random(22..38),
            date_of_birth: fn p -> Faker.Date.date_of_birth(p.age) end,
            experience: Enum.random(0..20),
            retired: false,
            local_popularity: Enum.random(1..6),
            national_popularity: Enum.random(1..6),
            position: position_or_key,
            uniform_number: Enum.random(1..99),
            free_agent: false,
            ability: Enum.random(20..80),
            talent: fn p -> p.ability end,
            team: fn -> build(:team) end
          }
          |> merge_attributes(attrs)
          |> evaluate_lazy_attributes()
        end
      end
    end
  end
end
