defmodule OOTPUtility.Leagues do
  @moduledoc """
  The Leagues context.
  """

  import Ecto.Query, warn: false
  alias OOTPUtility.Repo

  alias OOTPUtility.Leagues.{League, Level, Conference, Division}

  @doc """
  Returns the list of leagues.

  ## Examples

      iex> list_leagues()
      [%League{}, ...]

  """
  def list_leagues do
    Repo.all(League)
  end

  @doc """
  Gets a single league.

  Raises `Ecto.NoResultsError` if the League does not exist.

  ## Examples

      iex> get_league!(123)
      %League{}

      iex> get_league!(456)
      ** (Ecto.NoResultsError)

  """
  def get_league!(slug) do
    Repo.one!(
      from l in League,
        where: l.slug == ^slug,
        preload: [conferences: [:league, divisions: [:league, :conference, teams: [:record]]]]
    )
  end

  @doc """
  Returns a Leagues.Level struct for the specified league level

  ## Examples

    iex> get_league_level(:major)
    %Level{
      id: :major,
      abbr: "MLB",
      name: "Major League"
    }
  """
  @spec get_league_level(League.t() | atom() | binary()) :: Level.t()
  def get_league_level(%League{league_level: league_level}), do: get_league_level(league_level)

  def get_league_level(league_level) when is_binary(league_level) do
    league_level |> String.to_atom() |> get_league_level()
  end

  def get_league_level(league_level), do: Level.new(league_level)

  @doc """
  Returns the list of conferences for the specified league.

  ## Examples

      iex> list_conferences()
      [%Conference{}, ...]

  """
  def list_conferences do
    Repo.all(Conference)
  end

  @doc """
  Gets a single conference.

  Raises `Ecto.NoResultsError` if the Conference does not exist.

  ## Examples

      iex> get_conference!(123)
      %Conference{}

      iex> get_conference!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conference!(slug), do: Repo.one!(from c in Conference, where: c.slug == ^slug)

  def get_conference!(slug, league_slug) do
    Repo.one!(
      from c in Conference,
        join: l in League,
        on: l.id == c.league_id,
        where: l.slug == ^league_slug and c.slug == ^slug,
        preload: [:league, divisions: [:league, :conference, teams: [:record]]]
    )
  end

  @doc """
  Returns the list of divisions.

  ## Examples

      iex> list_divisions()
      [%Division{}, ...]

  """
  def list_divisions do
    Repo.all(Division)
  end

  @doc """
  Gets a single division.

  Raises `Ecto.NoResultsError` if the Division does not exist.

  ## Examples

      iex> get_division!(123)
      %Division{}

      iex> get_division!(456)
      ** (Ecto.NoResultsError)

  """
  def get_division!(slug), do: Repo.one!(from d in Division, where: d.slug == ^slug)

  def get_division!(slug, league_slug, conference_slug) do
    Repo.one!(
      from d in Division,
        join: c in Conference,
        on: c.id == d.conference_id,
        join: l in League,
        on: l.id == d.league_id,
        where: l.slug == ^league_slug and c.slug == ^conference_slug and d.slug == ^slug,
        preload: [:league, :conference, teams: [:record]]
    )
  end

  def get_division!(slug, league_slug) do
    Repo.one!(
      from d in Division,
        join: l in League,
        on: l.id == d.league_id,
        where: l.slug == ^league_slug and d.slug == ^slug,
        preload: [:league, teams: [:record]]
    )
  end
end
