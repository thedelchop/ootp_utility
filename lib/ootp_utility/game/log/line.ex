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
    field :formatted_text, :string
  end

  @doc """
  Take the Line's raw text, run it through the list of transformations
  and set the result as the Line's formatted text
  """
  @spec format_raw_text(Line.t(), []) :: String.t()
  def format_raw_text(line, generators) do
    # Here we need to go through the formatters and apply the correct one.
    Enum.find_value(generators, fn {regex, generator} ->
      if Regex.match?(regex, line.text) do
        regex
        |> Regex.named_captures(line.text)
        |> generator.()
      else
        nil
      end
    end)
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
