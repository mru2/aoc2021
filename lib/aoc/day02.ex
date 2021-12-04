defmodule Aoc.Day02 do
  import Aoc
  import Enum

  def parse(input),
    do:
      parse_lines(input)
      |> map(fn
        "forward " <> rest -> {String.to_integer(rest), 0}
        "down " <> rest -> {0, String.to_integer(rest)}
        "up " <> rest -> {0, -String.to_integer(rest)}
      end)

  def run(data) do
    {x, y} = reduce(data, fn {x1, y1}, {x2, y2} -> {x1 + x2, y1 + y2} end)
    x * y
  end

  def bonus(data) do
    {x, y, _a} =
      reduce(data, {0, 0, 0}, fn
        {0, aim}, {x, y, a} -> {x, y, a + aim}
        {fwd, _}, {x, y, a} -> {x + fwd, y + fwd * a, a}
      end)

    x * y
  end
end
