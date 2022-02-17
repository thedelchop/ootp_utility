defmodule OOTPUtility.Players.Attributes do
  alias OOTPUtility.Repo
  alias OOTPUtility.Players.{Attribute, Player}

  import Ecto.Query
  import OOTPUtility.Players, only: [is_pitcher: 1]

  @base_scale 200

  @doc """
    Returns a collection of `%Attribute{}` structs for the specified `%Player{}`.
    To allow the caller to further refine the attributes returned the following
    options can be passed to the function as options:

    * `include` - The class(es) of attributes to return with the query, can be one of:
      * :batting
      * :pitching
      * :pitches
      * :fielding
      * :positions
      * :baserunning
      * :bunting

      By default the function looks at the player's position, and if he is a pitcher, the
      pitching attributes will be returned, otherwise, the player's batting attributes
      will be returned.

    * `scale` - The value to use as the 'maximum' rating for the attributes, which will
      "scale" the attributes from 1 to `scale` instead of their normal range of 1-200.

      Note, to match the behaviour of OOTP itself, when scaling the attributes, all values
      will be rounded up to their nearest integer, this serves to simulate the "fog of war",
      where for example, on a scale of 1-10, the follow players have the same attributes:

      | Name     | Rating (200 scale) | Rating (10 scale) |
      |----------|--------------------|-------------------|
      | Player A | 141                |  8                |
      | Player B | 148                |  8                |
      | Player C | 158                |  8                |

    * type - One or many of the following may be specified:
      * :ability - The players current skill level
      * :ability_vs_right - The players current skill level vs right handed hitters or pitchers
      * :ability_vs_left  - The players current skill level vs left handed hitters or pitchers
      * :talent  - The players maximum skill level
    * preload - A Keyword list of the records that should be preloaded with the records.  While
      an attribute only has a Player association, since you could desire to load nested associations,
      a Keyword List was provided for this option, but it shold not be abused.
  """
  @spec for_player(Player.t(), Keyword.t()) :: [Ecto.Schema.t()]
  def for_player(player, opts \\ Keyword.new())

  def for_player(%Player{} = player, opts) do
    default_include = if is_pitcher(player), do: :pitching, else: :batting

    options =
      opts
      |> Keyword.put(:for, player)
      |> Keyword.put_new(:include, default_include)

    Attribute
    |> build_attribute_query(options)
    |> Repo.all()
  end

  defp build_attribute_query(query, []), do: query

  defp build_attribute_query(query, [opt | rest]) do
    case opt do
      {:include, includes} when is_list(includes) ->
        query
        |> where([a], a.name in ^attribute_names_for_includes(includes))
        |> build_attribute_query(rest)

      {:include, include} ->
        build_attribute_query(query, [{:include, [include]} | rest])

      {:scale, new_scale} ->
        query
        |> select(
          [a],
          %{
            a
            | value:
                fragment(
                  "trunc(ceil(?::double precision * ? / ?)):: integer",
                  a.value,
                  ^new_scale,
                  ^@base_scale
                )
          }
        )
        |> build_attribute_query(rest)

      {:type, types} when is_list(types) ->
        query
        |> where([a], a.type in ^types)
        |> build_attribute_query(rest)

      {:type, type} ->
        build_attribute_query(query, [{:type, [type]} | rest])

      {:for, %Player{id: player_id} = _player} ->
        query
        |> where([a], a.player_id == ^player_id)
        |> build_attribute_query(rest)

      {:preload, preloads} ->
        query
        |> preload(^preloads)
        |> build_attribute_query(rest)

      _ ->
        build_attribute_query(query, rest)
    end
  end

  defp attribute_names_for_includes(includes) do
    Enum.flat_map(includes, fn
      :pitches -> Attribute.pitches()
      :positions -> Attribute.positions()
      attr_name -> apply(Attribute, :"#{attr_name}_attributes", [])
    end)
    |> Enum.map(&Atom.to_string/1)
  end
end
