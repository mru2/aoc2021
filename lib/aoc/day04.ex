defmodule Aoc.Day04 do
  import Aoc
  import Enum

  def parse(input) do
    [roll | rest] = parse_lines(input)

    grids = rest |> chunk_every(5)

    {parse_numbers(roll, ","), map(grids, &parse_grid/1)}
  end

  def parse_grid(rows) do
    rows |> map(&parse_numbers(&1, " "))
  end

  def apply_roll(number, grid) do
    map(grid, fn row ->
      map(row, fn
        ^number -> 0
        other -> other
      end)
    end)
  end

  def winning?([
        [0, 0, 0, 0, 0],
        [_, _, _, _, _],
        [_, _, _, _, _],
        [_, _, _, _, _],
        [_, _, _, _, _]
      ]),
      do: true

  def winning?([
        [_, _, _, _, _],
        [0, 0, 0, 0, 0],
        [_, _, _, _, _],
        [_, _, _, _, _],
        [_, _, _, _, _]
      ]),
      do: true

  def winning?([
        [_, _, _, _, _],
        [_, _, _, _, _],
        [0, 0, 0, 0, 0],
        [_, _, _, _, _],
        [_, _, _, _, _]
      ]),
      do: true

  def winning?([
        [_, _, _, _, _],
        [_, _, _, _, _],
        [_, _, _, _, _],
        [0, 0, 0, 0, 0],
        [_, _, _, _, _]
      ]),
      do: true

  def winning?([
        [_, _, _, _, _],
        [_, _, _, _, _],
        [_, _, _, _, _],
        [_, _, _, _, _],
        [0, 0, 0, 0, 0]
      ]),
      do: true

  def winning?([
        [0, _, _, _, _],
        [0, _, _, _, _],
        [0, _, _, _, _],
        [0, _, _, _, _],
        [0, _, _, _, _]
      ]),
      do: true

  def winning?([
        [_, 0, _, _, _],
        [_, 0, _, _, _],
        [_, 0, _, _, _],
        [_, 0, _, _, _],
        [_, 0, _, _, _]
      ]),
      do: true

  def winning?([
        [_, _, 0, _, _],
        [_, _, 0, _, _],
        [_, _, 0, _, _],
        [_, _, 0, _, _],
        [_, _, 0, _, _]
      ]),
      do: true

  def winning?([
        [_, _, _, 0, _],
        [_, _, _, 0, _],
        [_, _, _, 0, _],
        [_, _, _, 0, _],
        [_, _, _, 0, _]
      ]),
      do: true

  def winning?([
        [_, _, _, _, 0],
        [_, _, _, _, 0],
        [_, _, _, _, 0],
        [_, _, _, _, 0],
        [_, _, _, _, 0]
      ]),
      do: true

  def winning?(_), do: false

  def sum_grid(grid), do: grid |> map(&sum/1) |> sum()

  def walk(numbers, grids, fun) do
    reduce_while(numbers, grids, fn number, grids ->
      new_grids = map(grids, &apply_roll(number, &1))

      fun.(new_grids, number)
    end)
  end

  def run({numbers, grids}) do
    walk(numbers, grids, fn new_grids, number ->
      case find(new_grids, &winning?/1) do
        nil -> {:cont, new_grids}
        grid -> {:halt, sum_grid(grid) * number}
      end
    end)
  end

  def bonus({numbers, grids}) do
    walk(numbers, grids, fn new_grids, number ->
      case new_grids do
        [last] ->
          if winning?(last) do
            {:halt, sum_grid(last) * number}
          else
            {:cont, [last]}
          end

        _ ->
          {:cont, reject(new_grids, &winning?/1)}
      end
    end)
  end
end
