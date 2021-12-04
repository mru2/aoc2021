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

    # if Kernel.function_exported?(module, :run, 1) do
      apply(module, :run, [parsed]) |> IO.inspect(label: "Run")
    # end

    # if Kernel.function_exported?(module, :bonus, 1) do
      apply(module, :bonus, [parsed]) |> IO.inspect(label: "Bonus")
    # end
  end
end
