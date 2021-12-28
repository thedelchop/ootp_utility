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
  def get_league!(id, opts \\ []) do
    dynamic([l], l.id == ^id)
    |> do_get_league(opts)
  end

  def get_league_by_slug!(
        slug,
        opts \\ []
      ) do
    dynamic([l], l.slug == ^slug)
    |> do_get_league(opts)
  end

  def do_get_league(where_clause, opts \\ []) do
    preloads =
      Keyword.get(opts, :preload,
        conferences: [:league, divisions: [:league, :conference, teams: [:record]]]
      )

    League
    |> where(^where_clause)
    |> preload(^preloads)
    |> Repo.one!()
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
  def get_conference!(id, opts \\ []) do
    dynamic([c], c.id == ^id)
    |> do_get_conference!(opts)
  end

  def get_conference_by_slug!(slug, opts \\ []) do
    dynamic([c], c.slug == ^slug)
    |> do_get_conference!(opts)
  end

  defp do_get_conference!(where_clause, opts) do
    preloads =
      Keyword.get(opts, :preload, [:league, divisions: [:league, :conference, teams: [:record]]])

    Conference
    |> join(:inner, [c], l in League, on: l.id == c.league_id)
    |> where(^where_clause)
    |> preload(^preloads)
    |> Repo.one!()
  end

  @doc """
  Returns the list of divisions.

  ## Examples

      iex> list_divisions()
      [%Division{}, ...]

  """
  @spec list_divisions() :: [Division.t()]
  def list_divisions do
    Repo.all(Division)
  end

  @doc """
  Gets a single division using its slug.

  Raises `Ecto.NoResultsError` if the Division does not exist.

  ## Examples

      iex> get_division_by_slug!("al-east")
      %Division{}

      iex> get_division_by_slug!("made-up-division")
      ** (Ecto.NoResultsError)

  """
  @spec get_division_by_slug!(String.t()) :: Division.t()
  def get_division_by_slug!(slug), do: Repo.one!(from d in Division, where: d.slug == ^slug)
end
