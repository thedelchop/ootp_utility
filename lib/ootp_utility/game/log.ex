defmodule OOTPUtility.Game.Log do
  require IEx

  alias OOTPUtility.Game.Log.Line
  alias OOTPUtility.Repo

  @moduledoc """
  The GameLog context.
  """

  @doc """
  Run all log lines that have yet to be formatted through the Log.Formatter, returns an error
  if there are still log lines that are unformatted an error is returned with an array of all
  the lines that were not processed by the formatter

  ## Examples

      iex> {:ok, lines_that_were_formatted} = Log.format_lines

      iex> {:error, lines_that_still_need_formatting} = Log.format_lines
  """
  @spec format_lines(Ecto.Query.t() | Line.t()) :: {:ok, [Line.t()]} | {:error, [Line.t()]}
  def format_lines(query \\ Line) do
    formatted_line_attrs =
      query
      |> Ecto.Queryable.to_query
      |> Line.unformatted
      |> Line.pitch_descriptions
      |> Repo.all
      |> Enum.map(fn
        line -> %{id: line.id, formatted_text: Line.format_raw_text(line)}
      end)

    Repo.insert_all(Line, formatted_line_attrs, on_conflict: {:replace, [:formatted_text]}, conflict_target: [:id])
  end

  @doc """
  Returns the raw_text of all log lines which are not yet formatted

  ## Examples

      iex> unformatted_lines()
  """
  @spec unformatted_lines() :: [String.t()]
  def unformatted_lines() do
      Line.unformatted
      |> Line.pitch_descriptions
      |> Line.raw_text
      |> Repo.all
  end

  @doc """
  Import the raw GameLog data from a file or director and insert them into the database

  ## Examples

      iex> import_from_file('priv/data/game_logs')
  """
  @spec import_from_dir(Path.t) :: [{String.t(), integer}]
  def import_from_dir(path) do
    path
    |> Path.join('/*.csv')
    |> Path.wildcard
    |> Enum.map(fn 
      file_path -> import_from_file(file_path)
    end)
  end

  @spec import_from_file(Path.t()) :: {String.t(), integer}
  defp import_from_file(path) do
    chunk_counts = path
      |> File.stream!
      |> Stream.map(&String.trim(&1))
      |> Stream.map(&HtmlSanitizeEx.strip_tags(&1))
      |> Stream.map(&String.replace(&1, ~r/\s+/, " "))
      |> Stream.map(&String.replace(&1, ~s("), ""))
      |> Stream.flat_map(&String.split(&1, "\n"))
      |> Stream.chunk_every(10_000)
      |> Stream.map(fn 
        stream -> import_from_list(stream)
      end)
      |> Enum.map(fn 
        event_changesets ->
          {count, _ } = Repo.insert_all(Event, event_changesets)

          count
      end)

    {path, Enum.sum(chunk_counts)}
  end

  @spec import_from_list([String.t()]) :: [%Line{}]
  defp import_from_list(stream) do
    stream
    |> Stream.map(&String.split(&1,","))
    |> Stream.filter(fn
      ["game_id" | _] -> false
      [""] -> false
      [_first | _ ] -> true
    end)
    |> Stream.map(fn
      [game_id, type, line, text | rest_of_text] ->
        [game_id, type, line, Enum.join([text | rest_of_text], ",")]
      [list] -> [list]
    end)
    |> Enum.map(fn
      [game_id, type, line, text] ->
        %{
          game_id: String.to_integer(game_id),
          type: String.to_integer(type),
          line: String.to_integer(line),
          raw_text: text
        }
      [game_id, type, line, text | rest_of_text] ->
        %{
          game_id: String.to_integer(game_id),
          type: String.to_integer(type),
          line: String.to_integer(line),
          raw_text: Enum.join([text | rest_of_text], ",")
        }
    end)
  end
end
