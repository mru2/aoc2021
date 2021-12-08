defmodule Aoc.Day08 do
  import Aoc
  import Enum, except: [split: 2]
  import MapSet, only: [size: 1, difference: 2, subset?: 2]
  import String, only: [split: 2, split: 3]

  def parse(input), do: input |> parse_lines() |> map(&parse_line/1)

  def parse_line(line) do
    parse_group = fn group -> group |> split(" ") |> map(&to_digit/1) end

    [signals, output] = split(line, " | ")
    {parse_group.(signals), parse_group.(output)}
  end

  def to_digit(string), do: string |> split("", trim: true) |> into(MapSet.new())

  @doc """
  Decode number based on segment count & included shapes
  (assuming all numbers are present in the input)

  Filter out those without ambiguity
   - 2 segments => 1
   - 3 segments => 7
   - 4 segments => 4
   - 7 segments => 9

  Remains 2 groups
   - 5 segments => 2, 3 or 5
   - 6 segments => 0, 6 or 9

  Extract 2 shapes

  shape of 1

     ....
    .    #
    .    #
     ....
    .    #
    .    #
     ....

  "L" : shape of 4 minus shape of 1

     ....
    #    .
    #    .
     ####
    .    .
    .    .
     ....

  For 5 segment group :
   - 3 includes "I"
   - 5 includes "L"
   - 2 includes none

  For 6 segment group :
   - 0 includes "I"
   - 6 includes "L"
   - 9 includes **both** (that's shape of 4)

  iex> ["acedgfb", "cdfbe", "gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab"]
  ...> |> Enum.map(&Aoc.Day08.to_digit/1)
  ...> |> Aoc.Day08.get_mapping()
  %{
    MapSet.new(["a", "b"]) => "1",
    MapSet.new(["a", "b", "d"]) => "7",
    MapSet.new(["a", "b", "e", "f"]) => "4",
    MapSet.new(["a", "b", "c", "d", "f"]) => "3",
    MapSet.new(["a", "c", "d", "f", "g"]) => "2",
    MapSet.new(["b", "c", "d", "e", "f"]) => "5",
    MapSet.new(["a", "b", "c", "d", "e", "f"]) => "9",
    MapSet.new(["a", "b", "c", "d", "e", "g"]) => "0",
    MapSet.new(["b", "c", "d", "e", "f", "g"]) => "6",
    MapSet.new(["a", "b", "c", "d", "e", "f", "g"]) => "8"
  }
  """
  def get_mapping(signals) do
    # Tally by count
    [[one], [seven], [four], five_segments, six_segments, [eight]] =
      2..7
      |> map(fn size ->
        signals |> filter(&(size(&1) == size)) |> uniq
      end)

    base = [
      {one, "1"},
      {seven, "7"},
      {four, "4"},
      {eight, "8"}
    ]

    l = difference(four, one)

    decode_five = fn digit ->
      cond do
        subset?(one, digit) -> "3"
        subset?(l, digit) -> "5"
        true -> "2"
      end
    end

    decode_six = fn digit ->
      cond do
        subset?(four, digit) -> "9"
        subset?(one, digit) -> "0"
        subset?(l, digit) -> "6"
      end
    end

    fives = map(five_segments, fn digit -> {digit, decode_five.(digit)} end)
    sixes = map(six_segments, fn digit -> {digit, decode_six.(digit)} end)

    (base ++ fives ++ sixes) |> into(%{})
  end

  @doc """
  iex> "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
  ...> |> Aoc.Day08.parse_line()
  ...> |> Aoc.Day08.decode_row()
  5353

  iex> "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  ...>  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  ...>  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  ...>  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  ...>  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  ...>  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  ...>  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  ...>  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  ...>  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  ...>  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
  ...> |> Aoc.Day08.parse()
  ...> |> Enum.map(&Aoc.Day08.decode_row/1)
  [8394, 9781, 1197, 9361, 4873, 8418, 4548, 1625, 8717, 4315]
  """
  def decode_row({signals, output}) do
    mapping = get_mapping(signals)
    output |> map(&Map.get(mapping, &1)) |> join |> to_i
  end

  def run(data) do
    data
    |> map(fn {_signals, output} ->
      filter(output, fn segment ->
        case size(segment) do
          2 -> true
          3 -> true
          4 -> true
          7 -> true
          _ -> false
        end
      end)
      |> length()
    end)
    |> sum()
  end

  def bonus(data), do: data |> map(&decode_row/1) |> IO.inspect() |> sum()
end
