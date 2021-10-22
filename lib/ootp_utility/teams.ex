defmodule OOTPUtility.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, only: [where: 3]

  alias OOTPUtility.Repo
  alias OOTPUtility.Teams.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
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

  def get_team_by_slug!(slug, opts) do
    preloads = Keyword.get(opts, :preload, [])

    Team
    |> where([t], t.slug == ^slug)
    |> Repo.one!()
    |> Repo.preload(preloads)
  end
end
