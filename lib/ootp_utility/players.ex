defmodule OOTPUtility.Players do
  @moduledoc """
  The Players context, which contains the public API for retreiving
  players, whether a single Player by its slug or all the players
  for a specific team.
  """

  import Ecto.Query, warn: false

  alias OOTPUtility.Repo
  alias OOTPUtility.Players.Player
  alias OOTPUtility.Teams.{Roster, Team}

  import OOTPUtility.Utilities, only: [expand_position_key: 1]

  @doc """
  Returns all players assoicated with a specified team, providing
  the following options:

    * `position` - The position of the players that should be
      returned, besides the traditional positions, also accepts,
      `IF`, `OF`, `SP`, `MR`, `CL`
    * `roster` - The roster type that should be returned, one of
      `:preseason`, `:active`, `:extended`, `:injured`
    * `order_by` - The field by which to order the players
      returned for the team.

  ## Examples

      iex> for_team(%Team{})
      [%Player{}, ...]
  """

  @spec for_team(Team.t(), Keyword.t()) :: [Ecto.Schema.t()]
  def for_team(%Team{} = team, opts \\ Keyword.new()) do
    do_for_team(team, opts)
  end

  defp do_for_team(query \\ Player, team, options)

  defp do_for_team(query, %Team{id: team_id}, []) do
    query
    |> where([p], p.team_id == ^team_id)
    |> preload([:league, :team])
    |> Repo.all()
  end

  defp do_for_team(query, %Team{id: team_id} = team, [option | rest]) do
    case option do
      {:position, "IF"} ->
        query
        |> where([p], p.position in ^[:first_base, :second_base, :third_base, :shortstop])
        |> do_for_team(team, rest)

      {:position, "OF"} ->
        query
        |> where([p], p.position in ^[:left_field, :center_field, :right_field])
        |> do_for_team(team, rest)

      {:position, "P"} ->
        query
        |> where([p], p.position in ^[:starting_pitcher, :middle_reliever, :closer])
        |> do_for_team(team, rest)

      {:position, position} ->
        query
        |> where([p], p.position == ^expand_position_key(position))
        |> do_for_team(team, rest)

      {:roster, roster_type} ->
        query
        |> join(:inner, [p], membership in Roster.Membership, on: membership.player_id == p.id)
        |> where([p, m], m.team_id == ^team_id and m.type == ^roster_type)
        |> do_for_team(team, rest)

      {:order_by, order_by_field} ->
        query
        |> order_by([p], field(p, ^order_by_field))
        |> do_for_team(team, rest)

      _ ->
        do_for_team(query, team, rest)
    end
  end

  @doc """
  Returns all players assoicated with a specified parent team, aka an organization

  ## Examples

      iex> for_organization(%Team{})
      [%Player{}, ...]

  """
  @spec for_organization(Team.t()) :: [Player.t()]
  def for_organization(%Team{organization: %Ecto.Association.NotLoaded{}} = team) do
    team
    |> Repo.preload(:organization)
    |> for_organization()
  end

  def for_organization(%Team{organization: %Team{id: organization_id}}) do
    Player
    |> where([p], p.organization_id == ^organization_id)
    |> Repo.all()
  end

  @doc """
  Returns the player's full name in various formats, which are currently:
    * `full` - The player's full first and last name
    * `short` - The player's first initial and last name

    iex> name(%Player{first_name: "Test", last_name: "Player"})
    "Test Player"

    iex> name(%Player{first_name: "Test", last_name: "Player"}, :full)
    "Test Player"

    iex> name(%Player{first_name: "Test", last_name: "Player"}, :short)
    "T. Player"
  """
  @type name_format :: :full | :short

  @spec name(Player.t(), name_format()) :: String.t()
  def name(player, format \\ :full)

  def name(%Player{first_name: first_name, last_name: last_name} = _player, :short) do
    "#{String.first(first_name)}. #{last_name}"
  end

  def name(%Player{first_name: first_name, last_name: last_name} = _player, :full) do
    first_name <> " " <> last_name
  end

  def name(nil, _format), do: nil

  @doc """
  Attempt to fetch a player by their slug

  Since player slugs are not guarenteed to be unique, will return:
    * `Player.t()` if the slug is exists and is unique
    * `[Player.t()]` if the slug exists but is not unique
    * `nil` if the slug does not exist

  ## Examples

      iex> get_player_by_slug("babe-ruth")
      %Player{}

      iex> get_player_by_slug("john-doe")
      [%Player{}, %Player{}]

      iex> get_player_by_slug("missing-player")
      ni

  """
  @spec get_player_by_slug(String.t()) :: Ecto.Schema.t() | [Ecto.Schema.t()] | nil
  def get_player_by_slug(slug) do
    players =
      Player
      |> where([p], p.slug == ^slug)
      |> preload([p], [:team, :league])
      |> Repo.all()

    case players do
      [] ->
        nil

      [player] ->
        player

      players ->
        players
    end
  end
end
