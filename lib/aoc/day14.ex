defmodule Aoc.Day14 do
  import Aoc
  import Enum

  def parse(input) do
    [template | rules] = parse_lines(input)

    sequence = parse_chars(template)

    rules =
      rules
      |> map(fn line ->
        [from, c] = String.split(line, " -> ")
        [a, b] = parse_chars(from)
        {{a, b}, c}
      end)
      |> into(%{})

    {sequence, rules}
  end

  def tally_pairs(sequence), do: tally_pairs(sequence, %{})
  def tally_pairs([_], acc), do: acc
  def tally_pairs([a, b | rest], acc), do: tally_pairs([b | rest], increment(acc, {a, b}))

  def walk(counts, rules) do
    reduce(counts, %{}, fn {{a, b}, count}, acc ->
      c = Map.fetch!(rules, {a, b})

      acc
      |> increment({a, c}, count)
      |> increment({c, b}, count)
    end)
  end

  def score(counts, sequence) do
    first = List.first(sequence)
    last = List.last(sequence)

    char_count = %{} |> increment(first) |> increment(last)

    {min, max} =
      counts
      |> reduce(char_count, fn {{a, b}, count}, acc ->
        acc |> increment(a, count) |> increment(b, count)
      end)
      |> Map.values()
      |> min_max()

    div(max, 2) - div(min, 2)
  end

  @doc """
  iex> Aoc.Day14.run({["N","N","C","B"], %{
  ...> {"C","H"} => "B",
  ...> {"H","H"} => "N",
  ...> {"C","B"} => "H",
  ...> {"N","H"} => "C",
  ...> {"H","B"} => "C",
  ...> {"H","C"} => "B",
  ...> {"H","N"} => "C",
  ...> {"N","N"} => "C",
  ...> {"B","H"} => "H",
  ...> {"N","C"} => "B",
  ...> {"N","B"} => "B",
  ...> {"B","N"} => "B",
  ...> {"B","B"} => "N",
  ...> {"B","C"} => "B",
  ...> {"C","C"} => "N",
  ...> {"C","N"} => "C"}})
  1588
  """
  def run({sequence, rules}, count \\ 10) do
    1..count |> reduce(tally_pairs(sequence), fn _i, counts -> walk(counts, rules) end) |> score(sequence)
  end

  def bonus(data) do
    run(data, 40)
  end
end
