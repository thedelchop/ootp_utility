defmodule OOTPUtility.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false

  alias OOTPUtility.Repo
  alias OOTPUtility.Players.Player
  alias OOTPUtility.Teams.Team

  @doc """
  Returns all players assoicated with a specified team

  ## Examples

      iex> for_team(%Team{})
      [%Player{}, ...]

  """

  def for_team(%Team{} = team, opts \\ Keyword.new()) do
    do_for_team(team, opts)
  end

  def do_for_team(query \\ Player, team, options)

  def do_for_team(query, %Team{id: team_id}, []) do
    query
    |> where([p], p.team_id == ^team_id)
    |> preload([:league, :team])
    |> Repo.all()
  end

  def do_for_team(query, team, [option | rest]) do
    case option do
      {:position, "IF"} ->
        query
        |> where([g], g.position in ^["1B", "2B", "3B", "SS"])
        |> do_for_team(team, rest)

      {:position, "OF"} ->
        query
        |> where([g], g.position in ^["LF", "CF", "RF"])
        |> do_for_team(team, rest)

      {:position, "P"} ->
        query
        |> where([g], g.position in ^["SP", "MR", "CL"])
        |> do_for_team(team, rest)

      {:position, position} ->
        query
        |> where([g], g.position == ^position)
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
  def for_organization(%Team{id: organization_id}) do
    Player
    |> where([p], p.organization_id == ^organization_id)
    |> Repo.all()
  end

  def name(player, format \\ :full)

  def name(%Player{first_name: first_name, last_name: last_name} = _player, :short) do
    "#{String.first(first_name)}. #{last_name}"
  end

  def name(%Player{first_name: first_name, last_name: last_name} = _player, :full) do
    first_name <> " " <> last_name
  end

  def name(nil, _format), do: nil

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(slug),
    do:
      Player
      |> where([p], p.slug == ^slug)
      |> preload([p], [:team, :league])
      |> Repo.one!()
end
