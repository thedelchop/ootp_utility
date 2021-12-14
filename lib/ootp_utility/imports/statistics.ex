defmodule OOTPUtility.Imports.Statistics do
  import OOTPUtility.Statistics, only: [calculate: 2, round: 2]

  def round_statistic(%Ecto.Changeset{changes: attrs} = changeset, stat) do
    Ecto.Changeset.change(changeset, %{
      stat => attrs |> Map.get(stat) |> round(stat)
    })
  end

  def add_statistic(%Ecto.Changeset{changes: attrs} = changeset, stat_name) do
    Ecto.Changeset.change(changeset, %{
      stat_name => calculate(attrs, stat_name)
    })
  end
end
