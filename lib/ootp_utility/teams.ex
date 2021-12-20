defmodule OOTPUtility.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query

  alias OOTPUtility.{Players, Repo}
  alias OOTPUtility.Teams.{Roster, Team}

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @spec get_roster(Team.t(), Roster.roster_type()) :: Roster.t()
  def get_roster(%Team{id: team_id} = team, type \\ :active) do
    players =
      Players.Player
      |> join(:inner, [p], membership in Roster.Membership, on: membership.player_id == p.id)
      |> where([p, m], m.team_id == ^team_id and m.type == ^type)
      |> Repo.all()

    %Roster{
      team: team,
      players: players,
      type: type
    }
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  def get_team_by_slug!(slug, opts \\ []) do
    preloads = Keyword.get(opts, :preload, [])

    Team
    |> where([t], t.slug == ^slug)
    |> Repo.one!()
    |> Repo.preload(preloads)
  end
end
