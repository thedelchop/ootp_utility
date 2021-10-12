defmodule OOTPUtility.Repo.Migrations.AddNicknameToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams), do: add(:nickname, :string)
  end
end
