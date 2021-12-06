defmodule Aoc.Day05 do
  import Aoc

  def parse(input) do
    input
    |> parse_lines()
    |> Enum.map(&parse_line/1)
  end

  @doc """
  iex> Aoc.Day05.parse_line("34,76 -> 745,787")
  {{34, 76}, {745, 787}}
  """
  def parse_line(line) do
    [_match, x1, y1, x2, y2] = Regex.run(~r/^(\d+),(\d+) -> (\d+),(\d+)$/, line)
    {{to_i(x1), to_i(y1)}, {to_i(x2), to_i(y2)}}
  end

  def incr_line({p1, p2}, grid) do
    Enum.reduce(line(p1, p2), grid, fn point, grid ->
      Map.update(grid, point, 1, &(&1 + 1))
    end)
  end

  def line({x1, y}, {x2, y}), do: for(x <- x1..x2, do: {x, y})
  def line({x, y1}, {x, y2}), do: for(y <- y1..y2, do: {x, y})
  def line({x1, y1}, {x2, y2}) when abs(x2 - x1) == abs(y2 - y1), do: Enum.zip(x1..x2, y1..y2)

  @doc """
  iex> Aoc.Day05.run([
  ...>   {{0,9},{5,9}},
  ...>   {{8,0},{0,8}},
  ...>   {{9,4},{3,4}},
  ...>   {{2,2},{2,1}},
  ...>   {{7,0},{7,4}},
  ...>   {{6,4},{2,0}},
  ...>   {{0,9},{2,9}},
  ...>   {{3,4},{1,4}},
  ...>   {{0,0},{8,8}},
  ...>   {{5,5},{8,2}}
  ...> ])
  5
  """
  def run(data) do
    data
    |> Enum.filter(fn
      {{x, _}, {x, _}} -> true
      {{_, y}, {_, y}} -> true
      _ -> false
    end)
    |> Enum.reduce(%{}, &incr_line/2)
    |> Enum.filter(fn {_point, val} -> val > 1 end)
    |> length()
  end

  @doc """
  iex> Aoc.Day05.bonus([
  ...>   {{0,9},{5,9}},
  ...>   {{8,0},{0,8}},
  ...>   {{9,4},{3,4}},
  ...>   {{2,2},{2,1}},
  ...>   {{7,0},{7,4}},
  ...>   {{6,4},{2,0}},
  ...>   {{0,9},{2,9}},
  ...>   {{3,4},{1,4}},
  ...>   {{0,0},{8,8}},
  ...>   {{5,5},{8,2}}
  ...> ])
  12
  """
  def bonus(data) do
    data
    |> Enum.reduce(%{}, &incr_line/2)
    |> Enum.filter(fn {_point, val} -> val > 1 end)
    |> length()
  end
end
