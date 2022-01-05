defmodule OOTPUtilityWeb.ComponentCase do
  @moduledoc """
  This module defines the test case to be used by tests that are
  exercising components in isolation, that is to say without a parent.

  Finally, if the test case interacts with the database, we enable the
  SQL sandbox, so changes done to the database are reverted at the end
  of every test. If you are using PostgreSQL, you can even run database
  tests asynchronously by setting
  `use OOTPUtilityWeb.ComponentCase, async: true`, although this option
  is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      alias OOTPUtility.Repo

      import Ecto
      import OOTPUtility.DataCase
      import OOTPUtility.Factory

      alias OOTPUtilityWeb.Router.Helpers, as: Routes

      use Snapshy
      use Surface.LiveViewTest

      # The default endpoint for testing
      @endpoint OOTPUtilityWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(OOTPUtility.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(OOTPUtility.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
    A helper to compare the results of SQL queries by just extracting their ids

    assert ids_for(Games.for_team(team)) == ids_for([game, game_1])
  """

  def ids_for(resources), do: resources |> Enum.map(& &1.id) |> Enum.sort()
end
