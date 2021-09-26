# Define a module to be used as base to handle composite keys
defmodule OOTPUtility.Schema do
  defmacro __using__(params) do
    composite_key = Keyword.get(params, :composite_key, nil)
    foreign_key = Keyword.get(params, :foreign_key, nil)

    quote do
      @type t() :: %__MODULE__{}

      use Ecto.Schema
      import Ecto.Changeset
      @primary_key {:id, :string, autogenerate: false}
      @foreign_key_type :string

      if not is_nil(unquote(composite_key)) do
        def generate_composite_key(struct),
          do: OOTPUtility.Schema.generate_composite_key(struct, unquote(composite_key))

        defoverridable generate_composite_key: 1

        def put_composite_key(%Ecto.Changeset{changes: changes} = changeset),
          do: change(changeset, %{id: __MODULE__.generate_composite_key(changes)})
      end

      if not is_nil(unquote(foreign_key)) do
        def generate_foreign_key(struct),
          do: OOTPUtility.Schema.generate_composite_key(struct, unquote(foreign_key))

        defoverridable generate_foreign_key: 1
      end
    end
  end

  def generate_composite_key(struct, keys) do
    keys
    |> Enum.map(&Map.get(struct, &1))
    |> Enum.join("-")
  end
end
