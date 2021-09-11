# Define a module to be used as base to handle composite keys
defmodule OOTPUtility.Schema do
  defmacro __using__(params) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      @primary_key {:id, :string, autogenerate: false}
      @foreign_key_type :string

      unless is_nil(unquote(params)) do
        def generate_composite_key(struct),
          do: OOTPUtility.Schema.generate_composite_key(struct, unquote(params[:composite_key]))

        def generate_foreign_key(struct),
          do: OOTPUtility.Schema.generate_composite_key(struct, unquote(params[:foreign_key]))

        defoverridable generate_composite_key: 1, generate_foreign_key: 1

        def put_composite_key(%Ecto.Changeset{changes: changes} = changeset),
          do: change(changeset, %{id: __MODULE__.generate_composite_key(changes)})
      end
    end
  end

  def generate_composite_key(struct, keys) do
    keys
    |> Enum.map(&Map.get(struct, &1))
    |> Enum.join("-")
  end
end