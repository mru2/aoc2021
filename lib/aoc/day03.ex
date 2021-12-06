defmodule Aoc.Day03 do
  import Aoc
  # import Enum

  def parse(input) do
    input
    |> parse_lines()
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> transpose
  end

  def bits_to_int(bits), do: bits |> Enum.join("") |> String.to_integer(2)

  def run(data) do
    tops = data |> Enum.map(&most_frequent/1) |> bits_to_int()
    bottoms = data |> Enum.map(&least_frequent/1) |> bits_to_int()

    tops * bottoms
  end

  def bonus(data) do
    nil
  end
end
