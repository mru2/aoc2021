defmodule Aoc.Day09 do
  import Aoc
  import Enum

  def parse(input) do
    input
    |> parse_lines()
    |> map(fn line ->
      line
      |> String.split("", trim: true)
      |> map(&to_i/1)
    end)
  end

  def get(_grid, {i, _j}) when i < 0, do: nil
  def get(_grid, {_i, j}) when j < 0, do: nil
  def get(grid, {i, j}), do: grid |> at(i) |> at(j)

  def apply_grid(grid, fun) do
    height = length(grid) - 1
    width = length(List.first(grid)) - 1

    for i <- 0..height do
      for j <- 0..width do
        value = get(grid, {i, j})

        neighbours =
          [
            {i - 1, j},
            {i + 1, j},
            {i, j - 1},
            {i, j + 1}
          ]
          |> reject(fn {i, j} -> i < 0 || j < 0 || i > height || j > width end)
          |> map(&get(grid, &1))

        fun.(value, neighbours, i * height + j)
      end
    end
  end

  def grid_values(grid), do: concat(grid)

  # Iterate function on item until stable
  def walk(val, fun) do
    case(fun.(val)) do
      ^val -> val
      new_val -> walk(new_val, fun)
    end
  end

  def map_low_points(grid, fun) do
    apply_grid(grid, fn val, neighbours, index ->
      case min(neighbours) do
        min when min > val -> fun.(val, index)
        _ -> val
      end
    end)
  end

  def run(data) do
    data
    |> map_low_points(fn val, _index -> {:low_point, val} end)
    |> grid_values()
    |> map(fn
      {:low_point, val} -> val + 1
      _ -> 0
    end)
    |> sum()
  end

  def bonus(data) do
    grow_groups = fn
      9, _, _ ->
        9

      {:group, i}, _, _ ->
        {:group, i}

      val, neighbours, _ ->
        case find(neighbours, &match?({:group, _}, &1)) do
          nil -> val
          group -> group
        end
    end

    data
    |> map_low_points(fn _val, index -> {:group, index} end)
    |> walk(&apply_grid(&1, grow_groups))
    |> grid_values()
    |> reject(&(&1 == 9))
    |> tally()
    |> take(3)
    |> map(fn {_group, count} -> count end)
    |> product()
  end
end
