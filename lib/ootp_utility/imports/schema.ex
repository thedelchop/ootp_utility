defmodule OOTPUtility.Imports.Schema do
  alias OOTPUtility.{Imports, Schema}

  defmacro __using__(opts) do
    filename = Keyword.fetch!(opts, :from)
    composite_key = Keyword.get(opts, :composite_key, nil)
    foreign_key = Keyword.get(opts, :foreign_key, nil)

    quote do
      @type t() :: %__MODULE__{}

      use Schema, composite_key: unquote(composite_key), foreign_key: unquote(foreign_key)

      use Imports, from: unquote(filename)

      import OOTPUtility.Imports.Schema
    end
  end

  defmacro import_schema(source, do: block) do
    quote do
      schema unquote(source), do: unquote(block)
    end
  end
end
