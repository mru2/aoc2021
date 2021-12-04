defmodule Aoc do
  @moduledoc """
  Various helpers
  """
  @spec parse_lines(binary) :: [String.t()]
  def parse_lines(input), do: String.split(input, "\n", trim: true)

  @spec parse_numbers(binary) :: [integer]
  def parse_numbers(input), do: input |> parse_lines() |> Enum.map(&String.to_integer/1)

  @spec pairs(any) :: [{any, any}]
  def pairs([h1, h2|rest]), do: [{h1, h2}|pairs([h2|rest])]
  def pairs(_), do: []

  @spec triplets(any) :: [{any, any, any}]
  def triplets([h1, h2, h3|rest]), do: [{h1, h2, h3}|triplets([h2, h3|rest])]
  def triplets(_), do: []
end
