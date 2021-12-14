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

  @doc """
  iex> grid = Aoc.Day11.parse("6594254334
  ...>                         3856965822
  ...>                         6375667284
  ...>                         7252447257
  ...>                         7468496589
  ...>                         5278635756
  ...>                         3287952832
  ...>                         7993992245
  ...>                         5957959665
  ...>                         6394862637")
  ...> Aoc.Day11.handle_step({grid, 0})
  {[
    [8,8,0,7,4,7,6,5,5,5],
    [5,0,8,9,0,8,7,0,5,4],
    [8,5,9,7,8,8,9,6,0,8],
    [8,4,8,5,7,6,9,6,0,0],
    [8,7,0,0,9,0,8,8,0,0],
    [6,6,0,0,0,8,8,9,8,9],
    [6,8,0,0,0,0,5,9,4,3],
    [0,0,0,0,0,0,7,4,5,6],
    [9,0,0,0,0,0,0,8,7,6],
    [8,7,0,0,0,0,6,8,4,8]], 35}
  """
  def handle_step({grid, _flashes} = acc) do
    {grid, flashes} = Grid.walk(grid, acc, &handle_bump/2)

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
