defmodule OOTPUtility.Factories.Utilities do
  def generate_id(), do: Integer.to_string(Enum.random(0..1000))

  def generate_slug_from_name(resource), do: Slug.slugify("#{resource.name}")

  def distribute_wins_amongst_teams(number_of_teams, games_per_team) do
    total_games_played = number_of_teams * games_per_team

    # Everybody wins 1/3 and losses 1/3, its the other 1/3 that matter
    minimum_wins = (games_per_team / 3) |> round() |> trunc()
    maximum_wins = (games_per_team * 2 / 3) |> round() |> trunc()

    {win_totals, _} =
      Enum.map_reduce(1..number_of_teams, total_games_played, fn
        _team, games_left ->
          wins = Faker.random_between(minimum_wins, maximum_wins)

          {wins, games_left - wins}
      end)

    win_totals
  end
end
