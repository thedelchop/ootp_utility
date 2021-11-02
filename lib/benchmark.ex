defmodule Benchmark do
  def measure(function) do
    seconds_to_run =
      function
      |> :timer.tc()
      |> elem(0)
      |> Kernel./(1_000_000)
      |> Kernel.round()

    minutes = Integer.floor_div(seconds_to_run, 60)
    seconds = Integer.mod(seconds_to_run, 60)

    IO.puts("The function took #{minutes}:#{seconds} minutes to run")
  end
end
