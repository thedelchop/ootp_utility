defmodule Benchmark do
  def measure(function, name \\ "function") do
    ms_to_run =
      function
      |> :timer.tc()
      |> elem(0)
      |> Kernel./(1_000)

    if ms_to_run > 1000 do
      seconds_to_run =
        ms_to_run
        |> Kernel./(1_000)
        |> Kernel.floor()

      minutes = Integer.floor_div(seconds_to_run, 60)
      seconds = Integer.mod(seconds_to_run, 60)

      IO.puts("#{name} finished in #{minutes}:#{seconds} minutes")
    else
      IO.puts("#{name} finished in #{ms_to_run} ms")
    end
  end
end
