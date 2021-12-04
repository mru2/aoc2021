defmodule Mix.Tasks.Aoc do
  @moduledoc "Printed when the user requests `mix help echo`"
  @shortdoc "mix aoc day1"

  require IEx

  use Mix.Task

  @impl Mix.Task

  def run(args) do
    [day | opts] = args

    {flags, _args, _invalid} = OptionParser.parse(opts, strict: [test: :boolean, ints: :boolean])

    file = case flags[:test] do
      true -> "inputs/#{day}.test"
      false -> "inputs/#{day}"
    end |> File.read!()

    input = cond do
      flags[:ints] == true -> Aoc.parse_numbers(file)
      true -> Aoc.parse_lines(file)
    end

    res = apply(Aoc, :run, [String.to_atom(day), input])

    Mix.shell().info(inspect(res))
  end
end
