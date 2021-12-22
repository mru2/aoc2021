defmodule Aoc.Day11 do
  import Aoc
  import Enum

  def parse(input), do: input |> parse_lines() |> map(&parse_digits/1) |> Grid.new()

  def handle_bump(coords, {grid, flashes}) do
    case grid[coords] do
      -1 ->
        {grid, flashes}

      9 ->
        bumped = {put_in(grid, [coords], -1), flashes + 1}
        reduce(Grid.neighbours(grid, coords), bumped, &handle_bump/2)

      n when n >= 0 and n < 9 ->
        {put_in(grid, [coords], n + 1), flashes}
    end
  end
  def handle_step({grid, flashes}) do
    {grid, flashes} = Grid.reduce_self(grid, flashes, &handle_bump/2)

    {Grid.map(grid, fn
       -1 -> 0
       n -> n
     end), flashes}
  end

  def run(data) do
    {_, flashes} =
      1..100
      |> Enum.reduce({data, 0}, fn _i, acc -> handle_step(acc) end)

    flashes
  end

  def bonus(grid), do: bonus(grid, 0)

  def bonus(grid, i) do
    case grid |> Grid.to_lists() |> concat() |> max() do
      0 ->
        i

      _ ->
        {new_grid, _} = handle_step({grid, 0})
        bonus(new_grid, i + 1)
    end
  end
end
