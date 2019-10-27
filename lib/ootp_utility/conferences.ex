defmodule OOTPUtility.Conferences do
  alias OOTPUtility.Repo
  alias OOTPUtility.Leagues.Conference

  def find_conference(id), do: Repo.get(Conference, id)
end
