defmodule OOTPUtility.Fixtures.Utilities do
  def generate_id() do
    Integer.to_string(Enum.random(0..1000))
  end
end
