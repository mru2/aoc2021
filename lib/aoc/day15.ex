defmodule Aoc.Day15 do
  import Aoc
  import Enum

  def parse(input) do
    input
    |> parse_lines()
    |> map(&parse_digits/1)
    |> Grid.new()
    |> Grid.map(fn i -> {i, 0} end)
  end

  def run(grid) do
    nil
  end

  def bonus(data), do: nil
end
