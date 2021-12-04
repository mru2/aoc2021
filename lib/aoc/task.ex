defmodule Mix.Tasks.Aoc do
  @moduledoc "Printed when the user requests `mix help echo`"
  @shortdoc "mix aoc day1"

  require IEx

  use Mix.Task


  @impl Mix.Task

  def run(args) do
    [day | opts] = args

    {flags, _args, _invalid} = OptionParser.parse(opts, strict: [test: :boolean, lines: :boolean])

    res = Aoc.run(Aoc.read(day, flags), String.to_atom(day))

    IO.inspect(res)
  end
end
