# Define a module to be used as base to handle composite keys
defmodule OOTPUtility.Schema do
  defmacro __using__(composite_key: keys) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      @primary_key {:id, :binary_id, autogenerate: false}
      @foreign_key_type :binary_id

      @composite_keys unquote(keys)

      def generate_composite_key(%_{} = struct) do
        struct
        |> Map.take(@composite_keys)
        |> Map.values()
        |> Enum.join("-")
      end
    end
  end

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      @primary_key {:id, :binary_id, autogenerate: false}
      @foreign_key_type :binary_id

      @composite_keys [:id]

      def generate_composite_key(%_{} = struct) do
        struct
        |> Map.take(@composite_keys)
        |> Map.values()
        |> Enum.join("-")
      end
    end
  end
end
