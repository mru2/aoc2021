defmodule Aoc.Day07 do
  import Aoc
  import Enum

  def parse(input) do
    input |> String.trim() |> parse_numbers(",")
  end

  def cost(nums, target) do
    nums |> map(&abs(&1 - target)) |> sum
  end

  @doc """
  iex> Aoc.Day07.triang(3)
  6
  iex> Aoc.Day07.triang(5)
  15
  iex> Aoc.Day07.triang(0)
  0
  """
  def triang(i), do: div(i * (i + 1), 2)

  def cost2(nums, target) do
    nums |> map(&triang(abs(&1 - target))) |> sum
  end

  @doc """
  iex> Aoc.Day07.run([16,1,2,0,4,2,7,1,2,14])
  37
  """
  def run(input) do
    {min, max} = min_max(input)

    target = min..max |> min_by(&cost(input, &1))

    cost(input, target)
  end

  @doc """
  iex> Aoc.Day07.bonus([16,1,2,0,4,2,7,1,2,14])
  168
  """
  def bonus(input) do
    {min, max} = min_max(input)

    target = min..max |> min_by(&cost2(input, &1))

    cost2(input, target)
  end
end
