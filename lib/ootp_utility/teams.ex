defmodule OOTPUtility.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query

  alias OOTPUtility.{Players, Repo}
  alias OOTPUtility.Teams.{Affiliation, Roster, Team}

  @team_abbreviation_regex ~r/(?<name>[\w\s]+)\s\([a-zA-z]{3}\)/

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

  @spec get_affiliates(Team.t(), Keyword.t()) :: [Team.t()]
  def get_affiliates(team, preloads \\ []) do
    Team
    |> join(:inner, [t], a in Affiliation, on: a.affiliate_id == t.id)
    |> where([t, a], a.team_id == ^team.id)
    |> order_by([t, _a], t.level)
    |> preload(^preloads)
    |> Repo.all()
  end

  @spec get_full_name(Team.t()) :: String.t()
  def get_full_name(%Team{name: name, nickname: nil}), do: name

  def get_full_name(%Team{name: name, nickname: nickname}) do
    name = if Regex.match?(@team_abbreviation_regex, name) do
      %{"name" => name_without_team_abbr} = Regex.named_captures(@team_abbreviation_regex, name)

      name_without_team_abbr
    end

    "#{name} #{nickname}"
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
    |> preload(^preloads)
    |> Repo.one!()
  end
end
