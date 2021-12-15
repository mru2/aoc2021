defmodule Aoc.Day13 do
  import Aoc
  import Enum

  def parse(input) do
    [points, splits] = input |> String.split("\n\n") |> map(&parse_lines/1)

    points =
      points
      |> map(fn line ->
        [x, y] = line |> String.split(",") |> map(&to_i/1)
        {x, y}
      end)
      |> into(MapSet.new())

    splits =
      splits
      |> map(fn
        "fold along x=" <> split -> {:x, to_i(split)}
        "fold along y=" <> split -> {:y, to_i(split)}
      end)

    {points, splits}
  end

  def handle_split({x, y}, {:x, split}) when x <= split, do: {x, y}
  def handle_split({x, y}, {:x, split}) when x > split, do: {split * 2 - x, y}
  def handle_split({x, y}, {:y, split}) when y <= split, do: {x, y}
  def handle_split({x, y}, {:y, split}) when y > split, do: {x, split * 2 - y}

  def handle_split(%MapSet{} = grid, split) do
    grid |> map(fn point -> handle_split(point, split) end) |> into(MapSet.new())
  end

  def print(grid) do
    width = grid |> map(fn {x, _} -> x end) |> max
    height = grid |> map(fn {_, y} -> y end) |> max

    IO.write("\n")

    for y <- 0..(height) do
      for x <- 0..(width) do
        case MapSet.member?(grid, {x, y}) do
          true -> IO.write("#")
          false -> IO.write(" ")
        end
      end

      IO.write("\n")
    end

    IO.write("\n")

    nil
  end

  def run({grid, [split | _rest]}) do
    handle_split(grid, split) |> count()
  end

  def bonus({grid, splits}) do
    splits |> reduce(grid, fn split, acc -> handle_split(acc, split) end) |> print()
  end
end
