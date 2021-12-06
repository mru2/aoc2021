defmodule Aoc do
  @moduledoc """
  Various helpers
  """
  @spec parse_lines(binary) :: [String.t()]
  def parse_lines(input), do: String.split(input, "\n", trim: true)

  @spec parse_numbers(binary, binary) :: [integer]
  def parse_numbers(input, sep \\ "\n"), do: input |> String.split(sep, trim: true) |> Enum.map(&to_i/1)

  @spec pairs(any) :: [{any, any}]
  def pairs([h1, h2 | rest]), do: [{h1, h2} | pairs([h2 | rest])]
  def pairs(_), do: []

  @spec triplets(any) :: [{any, any, any}]
  def triplets([h1, h2, h3 | rest]), do: [{h1, h2, h3} | triplets([h2, h3 | rest])]
  def triplets(_), do: []

  @spec transpose([list]) :: [list]
  def transpose(rows), do: List.zip(rows) |> Enum.map(&Tuple.to_list/1)

  def to_i(str), do: String.to_integer(str)

  def tally(list),
    do: list |> Enum.group_by(& &1) |> Enum.map(fn {val, elems} -> {val, length(elems)} end)

  def most_frequent(list),
    do: list |> tally() |> Enum.max_by(fn {_val, count} -> count end) |> elem(0)

  def least_frequent(list),
    do: list |> tally() |> Enum.min_by(fn {_val, count} -> count end) |> elem(0)
end
