defmodule Aoc do
  @moduledoc """
  Documentation for `Aoc`.
  """

  @spec parse_lines(binary) :: [String.t()]
  def parse_lines(input), do: String.split(input, "\n", trim: true)

  @spec parse_numbers(binary) :: [integer]
  def parse_numbers(input), do: input |> parse_lines() |> Enum.map(&String.to_integer/1)


  # def run(1, input) do

  # end

  def run(_, input) do
    input
  end
end
