defmodule OOTPUtility.Players.Ratings do
  @moduledoc """
    This module handles the public API for dealing with the ratings that are assigned to players,
    for the following aspects of their play:

      * Batting
      * Running
      * Fielding
      * Positions
      * Pitching
      * Pitches

    ## Rating types

    The Batting, Pitching and Pitches Ratings make use of a `type` field which dictates which specific rating is
    being represented by this record.

    The types are as follows:

    <dl>
      <dt>Batting Rating Types</dt>
      <dd>
        <ul>
          <li>Ability - The players ability at the current moment in time</li>
          <li>Ability Vs Left - The players ability at the current moment in time versus left handed pitchers</li>
          <li>Ability Vs Right - The players ability at the current moment in time versus right handed pitchers</li>
          <li>Talent - The rating that represents the highest ability rating the player may reach in the future</li>
        </ul>
      </dd>

      <dt>Pitching Rating Types</dt>
      <dd>
        <ul>
          <li>Ability - The players ability at the current moment in time</li>
          <li>Ability Vs Left - The players ability at the current moment in time versus left handed batters</li>
          <li>Ability Vs Right - The players ability at the current moment in time versus right handed batters</li>
          <li>Talent - The rating that represents the highest ability rating the player may reach in the future</li>
        </ul>
      </dd>

      <dt>Pitches Rating Types</dt>
      <dd>
        <ul>
          <li>Ability - The players ability at the current moment in time for the specific pitch</li>
          <li>Talent - The rating that represents the highest ability rating the player may reach in the future for the specific pitch</li>
        </ul>
      </dd>
    </dl>
  """
  alias __MODULE__

  alias OOTPUtility.{Players, Repo}

  import Ecto.Query

  @type t() ::
          Ratings.Batting.t()
          | Ratings.Pitching.t()
          | Ratings.Fielding.t()
          | Ratings.Running.t()
          | Ratings.Pitches.t()
          | Ratings.Position.t()

  @doc """

    Returns all of the Players.Ratings.Batting for the specified Player.

    ## Examples
    iex> Players.Ratings.batting_ratings_for(%Player{})
      [%Players.Ratings.Batting{}]
  """
  @spec batting_ratings_for(Players.Player.t()) :: [Ecto.Schema.t()]
  def batting_ratings_for(player), do: ratings_for(player, Ratings.Batting)

  @doc """

    Returns all of the Players.Ratings.Pitching for the specified Player.

    ## Examples
    iex> Players.Ratings.pitching_ratings_for(%Player{})
      [%Players.Ratings.Pitching{}]
  """
  @spec pitching_ratings_for(Players.Player.t()) :: [Ecto.Schema.t()]
  def pitching_ratings_for(%Players.Player{} = player), do: ratings_for(player, Ratings.Pitching)

  @doc """
    Takes an array of Ratings and returns a Keyword list of the attributes and the players
    rating for the different types.

    ## Examples
    iex> Players.Ratings.grouped_by_attributes([%Players.Ratings.Batting{}, ...])
      [
        contact: [talent: 138, ability: 125, ability_vs_left: 123, ability_vs_right: 127]
        gap_power: [talent: 138, ability: 125, ability_vs_left: 123, ability_vs_right: 127]
        home_run_power: [talent: 138, ability: 125, ability_vs_left: 123, ability_vs_right: 127]
        eye: [talent: 138, ability: 125, ability_vs_left: 123, ability_vs_right: 127]
        avoids_strikeouts: [talent: 138, ability: 125, ability_vs_left: 123, ability_vs_right: 127]
      ]
  """

  @type attribute_ratings ::
          {:ability, integer()}
          | {:talent, integer()}
          | {:ability_vs_left, integer()}
          | {:ability_vs_right, integer()}

  @type batting_attributes ::
          {:contact, [attribute_ratings()]}
          | {:gap_power, [attribute_ratings()]}
          | {:home_run_power, [attribute_ratings()]}
          | {:eye, [attribute_ratings()]}
          | {:avoid_strikeouts, [attribute_ratings()]}

  @type pitching_attributes ::
          {:stuff, [attribute_ratings()]}
          | {:movement, [attribute_ratings()]}
          | {:controll, [attribute_ratings()]}

  @spec grouped_by_attributes([Ratings.Batting.t() | Ratings.Pitching.t()]) ::
          pitching_attributes() | batting_attributes()
  def grouped_by_attributes([%module{} | _] = ratings) when module == Ratings.Batting do
    ratings
    |> Enum.reduce(
      [
        contact: Keyword.new(),
        gap_power: Keyword.new(),
        home_run_power: Keyword.new(),
        eye: Keyword.new(),
        avoid_strikeouts: Keyword.new()
      ],
      fn
        %Players.Ratings.Batting{
          type: type,
          contact: contact,
          gap_power: gap_power,
          home_run_power: home_run_power,
          eye: eye,
          avoid_strikeouts: avoid_strikeouts
        },
        acc ->
          acc
          |> update_in([:contact, type], fn _ -> contact end)
          |> update_in([:gap_power, type], fn _ -> gap_power end)
          |> update_in([:home_run_power, type], fn _ -> home_run_power end)
          |> update_in([:eye, type], fn _ -> eye end)
          |> update_in([:avoid_strikeouts, type], fn _ -> avoid_strikeouts end)
      end
    )
  end

  def grouped_by_attributes([]), do: []

  def grouped_by_attributes([%module{} | _] = ratings) when module == Ratings.Pitching do
    ratings
    |> Enum.reduce(
      [
        stuff: Keyword.new(),
        movement: Keyword.new(),
        control: Keyword.new()
      ],
      fn
        %Players.Ratings.Pitching{
          type: type,
          stuff: stuff,
          movement: movement,
          control: control
        },
        acc ->
          acc
          |> update_in([:stuff, type], fn _ -> stuff end)
          |> update_in([:movement, type], fn _ -> movement end)
          |> update_in([:control, type], fn _ -> control end)
      end
    )
  end

  defp ratings_for(%Players.Player{id: player_id} = _player, schema) do
    schema
    |> where([r], r.player_id == ^player_id)
    |> Repo.all()
  end
end
