defmodule OOTPUtility.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, only: [from: 2]

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

  def get_team_by_slug!(slug), do:
      Repo.one!(
        from t in Team,
          where: t.slug == ^slug
      )
end
