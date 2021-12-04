defmodule Aoc.Day01 do
  import Aoc
  import Enum

  def parse(input), do: parse_numbers(input)

  @doc """
  iex> Aoc.Day01.run([199,200,208,210,200,207,240,269,260,263])
  7
  """
  def run(data),
    do:
      data
      |> pairs()
      |> filter(fn {a, b} -> b > a end)
      |> length()

  @doc """
  iex> Aoc.Day01.bonus([199,200,208,210,200,207,240,269,260,263])
  5
  """
  def bonus(data),
    do:
      data
      |> triplets()
      |> map(fn {a, b, c} -> a + b + c end)
      |> pairs()
      |> filter(fn {a, b} -> b > a end)
      |> length()
end
