defmodule Aoc.Day17 do
  import Aoc
  import Enum

  def parse(input) do
    [_match, x1, x2, y2, y1] =
      Regex.run(~r/^target area: x=(\d+)..(\d+), y=-(\d+)..-(\d+)$/, input)

    {to_i(x1), to_i(x2), -to_i(y1), -to_i(y2)}
  end

  def drag({0, vy}), do: {0, vy - 1}
  def drag({vx, vy}) when vx > 0, do: {vx - 1, vy - 1}

  @doc """
  iex> Aoc.Day17.hits?({0, 0}, {7, 2}, {20, 30, -5, -10})
  true
  iex> Aoc.Day17.hits?({0, 0}, {6, 3}, {20, 30, -5, -10})
  true
  iex> Aoc.Day17.hits?({0, 0}, {9, 0}, {20, 30, -5, -10})
  true
  iex> Aoc.Day17.hits?({0, 0}, {17, -4}, {20, 30, -5, -10})
  false
  """
  def hits?(v, target), do: hits?({0, 0}, v, target)
  def hits?({x, _y}, _v, {_x1, x2, _y1, _y2}) when x > x2, do: false
  def hits?({_x, y}, _v, {_x1, _x2, _y1, y2}) when y < y2, do: false

  def hits?({x, y}, _v, {x1, x2, y1, y2}) when x >= x1 and x <= x2 and y <= y1 and y >= y2,
    do: true

  def hits?({x, y}, {vx, vy}, target) do
    hits?({x + vx, y + vy}, drag({vx, vy}), target)
  end

  def trajectories({_x1, x2, _y1, y2} = target),
    do: for(vx <- 0..x2, vy <- y2..100, do: {vx, vy}) |> filter(&hits?(&1, target))

  def trig(n), do: round(n * (n + 1) / 2)

  def run(target) do
    {_vx, vy} =
      target
      |> trajectories()
      |> max_by(fn {_vx, vy} -> vy end)

    trig(vy)
  end

  def bonus(target) do
    target |> trajectories() |> length()
  end
end
