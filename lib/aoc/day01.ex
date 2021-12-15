defmodule Aoc.Day01 do
  import Aoc
  import Enum

  def parse(input), do: parse_numbers(input)

  def pairs([h1, h2 | rest]), do: [{h1, h2} | pairs([h2 | rest])]
  def pairs(_), do: []

  def triplets([h1, h2, h3 | rest]), do: [{h1, h2, h3} | triplets([h2, h3 | rest])]
  def triplets(_), do: []

  @doc """
  iex> Aoc.Day01.run([199,200,208,210,200,207,240,269,260,263])
  7
  """
  def run(data),
    do:
      data
      |> pairs()
      |> count(fn {a, b} -> b > a end)

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
      |> count(fn {a, b} -> b > a end)
end
