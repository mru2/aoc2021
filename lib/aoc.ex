defmodule Aoc do
  @moduledoc """
  Various helpers
  """
  def parse_lines(input), do: String.split(input, "\n", trim: true)

  def parse_numbers(input, sep \\ "\n"), do: input |> String.split(sep, trim: true) |> Enum.map(&to_i/1)

  def parse_chars(input), do: String.split(input, "", trim: true)

  def pairs([h1, h2 | rest]), do: [{h1, h2} | pairs([h2 | rest])]
  def pairs(_), do: []

  def triplets([h1, h2, h3 | rest]), do: [{h1, h2, h3} | triplets([h2, h3 | rest])]
  def triplets(_), do: []

  def transpose(rows), do: List.zip(rows) |> Enum.map(&Tuple.to_list/1)

  def to_i(str), do: String.to_integer(str)

  def tally(list),
    do: list |> Enum.group_by(& &1) |> Enum.map(fn {val, elems} -> {val, length(elems)} end) |> Enum.sort_by(fn {_val, len} -> -len end)

  def most_frequent(list),
    do: list |> tally() |> Enum.max_by(fn {_val, count} -> count end) |> elem(0)

  def least_frequent(list),
    do: list |> tally() |> Enum.min_by(fn {_val, count} -> count end) |> elem(0)
end
