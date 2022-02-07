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

  def batting_ratings_for(%Players.Player{id: player_id} = _player) do
    Ratings.Batting
    |> where([r], r.player_id == ^player_id)
    |> Repo.all()
  end

  def pitching_ratings_for(%Players.Player{id: player_id} = _player) do
    Ratings.Pitching
    |> where([r], r.player_id == ^player_id)
    |> Repo.all()
  end
end
