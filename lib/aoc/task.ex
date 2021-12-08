defmodule Mix.Tasks.Aoc do
  @moduledoc "Printed when the user requests `mix help echo`"
  @shortdoc "cat input | mix aoc 01"

  use Mix.Task

  @impl Mix.Task



  def run(args) do
    [day] = args

    module = :"Elixir.Aoc.Day#{day}"
    Code.ensure_compiled! module

    data = IO.read(:all)

    parsed = apply(module, :parse, [data]) |> IO.inspect(label: "Data")

    {time, res} = :timer.tc(fn -> apply(module, :run, [parsed]) end)
    IO.puts "Run: #{res} (#{time / 1000} ms)"

    {time, res} = :timer.tc(fn -> apply(module, :bonus, [parsed]) end)
    IO.puts "Run: #{res} (#{time / 1000} ms)"
  end
end
