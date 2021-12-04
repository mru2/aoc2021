defmodule Aoc do
  @moduledoc """
  Documentation for `Aoc`.
  """

  def read(day, flags) do
    file =
      if flags[:tset] do
        "inputs/#{day}.test"
      else
        "inputs/#{day}"
      end
      |> File.read!()

    cond do
      flags[:raw] == true -> String.trim(file)
      flags[:lines] == true -> parse_lines(file)
      true -> parse_numbers(file)
    end
  end


  @spec parse_lines(binary) :: [String.t()]
  def parse_lines(input), do: String.split(input, "\n", trim: true)

  @spec parse_numbers(binary) :: [integer]
  def parse_numbers(input), do: input |> parse_lines() |> Enum.map(&String.to_integer/1)

  @spec pairs(any) :: [{any, any}]
  def pairs([h1, h2|rest]), do: [{h1, h2}|pairs([h2|rest])]
  def pairs(_), do: []

  @spec triplets(any) :: [{any, any, any}]
  def triplets([h1, h2, h3|rest]), do: [{h1, h2, h3}|triplets([h2, h3|rest])]
  def triplets(_), do: []


  @doc """
  iex> Aoc.run([199,200,208,210,200,207,240,269,260,263], :day1)
  {7, 5}
  """
  def run(input, :day1) do
    first = pairs(input) |> Enum.filter(fn {a, b} -> b > a end) |> length()
    second = triplets(input) |> Enum.map(fn {a, b, c} -> a + b + c end) |> pairs() |> Enum.filter(fn {a, b} -> b > a end) |> length()
    {first, second}
  end

  def run(_, input) do
    input
  end
end
