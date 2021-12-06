defmodule Aoc.Day06 do
  import Aoc

  @base %{
    0 => 0,
    1 => 0,
    2 => 0,
    3 => 0,
    4 => 0,
    5 => 0,
    6 => 0,
    7 => 0,
    8 => 0
  }

  def parse(input) do
    input |> String.trim() |> String.split(",", trim: true) |> Enum.map(&to_i/1)
  end

  @doc """
  iex> Aoc.Day06.run([3,4,3,1,2], 18)
  26
  """
  def run(data, runs \\ 80) do
    counts = tally(data) |> Enum.into(%{})

    Enum.reduce(1..runs, Map.merge(@base, counts), fn _,
                                                      %{
                                                        0 => i0,
                                                        1 => i1,
                                                        2 => i2,
                                                        3 => i3,
                                                        4 => i4,
                                                        5 => i5,
                                                        6 => i6,
                                                        7 => i7,
                                                        8 => i8
                                                      } ->
      %{
        0 => i1,
        1 => i2,
        2 => i3,
        3 => i4,
        4 => i5,
        5 => i6,
        6 => i7 + i0,
        7 => i8,
        8 => i0
      }
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def bonus(data), do: run(data, 256)
end
