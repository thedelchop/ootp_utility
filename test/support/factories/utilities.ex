defmodule OOTPUtility.Factories.Utilities do
  def generate_id(), do: Integer.to_string(Enum.random(0..1000))

  def generate_slug_from_name(resource), do: Slug.slugify("#{resource.name}")
end
