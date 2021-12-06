defmodule Aoc.Day03 do
  import Aoc
  import Enum

  def parse(input) do
    input
    |> parse_lines()
    |> map(&String.split(&1, "", trim: true))
  end

  def bits_to_int(bits), do: bits |> join("") |> String.to_integer(2)

  @doc """
  iex> Aoc.Day03.run([
  ...>   ["0","0","1","0","0"],
  ...>   ["1","1","1","1","0"],
  ...>   ["1","0","1","1","0"],
  ...>   ["1","0","1","1","1"],
  ...>   ["1","0","1","0","1"],
  ...>   ["0","1","1","1","1"],
  ...>   ["0","0","1","1","1"],
  ...>   ["1","1","1","0","0"],
  ...>   ["1","0","0","0","0"],
  ...>   ["1","1","0","0","1"],
  ...>   ["0","0","0","1","0"],
  ...>   ["0","1","0","1","0"],
  ...> ])
  198
  """
  def run(data) do
    cols = transpose(data)
    tops = cols |> map(&most_frequent/1) |> bits_to_int()
    bottoms = cols |> map(&least_frequent/1) |> bits_to_int()

    tops * bottoms
  end

  @doc """
  iex> Aoc.Day03.bonus([
  ...>   ["0","0","1","0","0"],
  ...>   ["1","1","1","1","0"],
  ...>   ["1","0","1","1","0"],
  ...>   ["1","0","1","1","1"],
  ...>   ["1","0","1","0","1"],
  ...>   ["0","1","1","1","1"],
  ...>   ["0","0","1","1","1"],
  ...>   ["1","1","1","0","0"],
  ...>   ["1","0","0","0","0"],
  ...>   ["1","1","0","0","1"],
  ...>   ["0","0","0","1","0"],
  ...>   ["0","1","0","1","0"],
  ...> ])
  230
  """
  def bonus(data) do
    oxy = walk_cols(data, fn col -> col |> tally() |> max_or_1() end) |> bits_to_int()
    co2 = walk_cols(data, fn col -> col |> tally() |> min_or_0() end) |> bits_to_int()

    oxy * co2
  end

  def min_or_0([{_a, na}, {_b, nb}]) when na == nb, do: "0"
  def min_or_0([{_a, na}, {b, nb}]) when na > nb, do: b
  def min_or_0([{a, na}, {_b, nb}]) when na < nb, do: a

  def max_or_1([{_a, na}, {_b, nb}]) when na == nb, do: "1"
  def max_or_1([{a, na}, {_b, nb}]) when na > nb, do: a
  def max_or_1([{_a, na}, {b, nb}]) when na < nb, do: b

  def walk_cols(data, fun) do
    length = data |> List.first() |> length()

    reduce_while(1..length, data, fn col, rows ->
      filter = rows
      |> map(&at(&1, col - 1))
      |> fun.()

      case reject(rows, &(at(&1, col - 1) != filter)) do
        [row] -> {:halt, row}
        rows -> {:cont, rows}
      end
    end)
  end
end
