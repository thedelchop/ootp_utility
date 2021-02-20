defmodule OOTPUtility.Game.Log.Line do
  @type t() :: %__MODULE__{}

  use OOTPUtility.Schema, composite_key: [:game_id, :line]

  import Ecto.Query, only: [order_by: 3, where: 3]
  import Ecto.Queryable, only: [to_query: 1]

  alias __MODULE__

  schema "game_log_lines" do
    field :game_id, :integer
    field :line, :integer
    field :text, :string
    field :type, :integer
  end

  @doc """
  Return a query that scopes the lines to a specified game
  """
  @spec for_game(number) :: Ecto.Query.t()
  def for_game(game_id), do: for_game(Line, game_id)

  @spec for_game(Ecto.Queryable.t(), number) :: Ecto.Query.t()
  def for_game(query, game_id) do
    query
    |> to_query()
    |> where([l], l.game_id == ^game_id)
    |> order_by([l], [l.game_id, l.line])
  end

  @spec parse(Line.t()) :: Line.t()
  def parse(line) do
    line
  end
end
