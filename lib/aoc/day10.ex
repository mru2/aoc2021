defmodule Aoc.Day10 do
  import Aoc
  import Enum

  def parse(input), do: input |> parse_lines() |> map(&parse_chars/1)

  @doc """
  iex> "{([(<{}[<>[]}>{[]{[(<()>" |> Aoc.parse_chars() |> Aoc.Day10.check()
  {:corrupted, "}"}
  iex> "[[<[([]))<([[{}[[()]]]" |> Aoc.parse_chars() |> Aoc.Day10.check()
  {:corrupted, ")"}
  iex> "[{[{({}]{}}([{[{{{}}([]" |> Aoc.parse_chars() |> Aoc.Day10.check()
  {:corrupted, "]"}
  iex> "[<(<(<(<{}))><([]([]()" |> Aoc.parse_chars() |> Aoc.Day10.check()
  {:corrupted, ")"}
  iex> "<{([([[(<>()){}]>(<<{{" |> Aoc.parse_chars() |> Aoc.Day10.check()
  {:corrupted, ">"}
  iex> "[({(<(())[]>[[{[]{<()<>>" |> Aoc.parse_chars() |> Aoc.Day10.check()
  {:incomplete, ["{", "{", "[", "[", "(", "{", "(", "["]}
  """
  def check(line), do: check(line, [])
  def check([], []), do: :complete
  def check([], openers), do: {:incomplete, openers}
  def check([char | rest], acc) when char in ["(", "[", "{", "<"], do: check(rest, [char | acc])
  def check([")" | rest], ["(" | acc]), do: check(rest, acc)
  def check(["]" | rest], ["[" | acc]), do: check(rest, acc)
  def check(["}" | rest], ["{" | acc]), do: check(rest, acc)
  def check([">" | rest], ["<" | acc]), do: check(rest, acc)
  def check([char | _], _rest), do: {:corrupted, char}

  @doc """
  iex> Aoc.Day10.score(["{", "{", "[", "[", "(", "{", "(", "["])
  288957
  """
  def score(openers), do: score(openers, 0)
  def score([], acc), do: acc
  def score(["(" | rest], acc), do: score(rest, acc * 5 + 1)
  def score(["[" | rest], acc), do: score(rest, acc * 5 + 2)
  def score(["{" | rest], acc), do: score(rest, acc * 5 + 3)
  def score(["<" | rest], acc), do: score(rest, acc * 5 + 4)

  @doc """
  iex> input = "[({(<(())[]>[[{[]{<()<>>
  ...>[(()[<>])]({[<{<<[]>>(
  ...>{([(<{}[<>[]}>{[]{[(<()>
  ...>(((({<>}<{<{<>}{[]{[]{}
  ...>[[<[([]))<([[{}[[()]]]
  ...>[{[{({}]{}}([{[{{{}}([]
  ...>{<[[]]>}<{[{[{[]{()[[[]
  ...>[<(<(<(<{}))><([]([]()
  ...><{([([[(<>()){}]>(<<{{
  ...><{([{{}}[<[[[<>{}]]]>[]]"
  ...> input |> Aoc.Day10.parse() |> Aoc.Day10.run()
  26397
  """
  def run(data) do
    data
    |> map(&check/1)
    |> map(fn
      :complete -> 0
      {:incomplete, _} -> 0
      {:corrupted, ")"} -> 3
      {:corrupted, "]"} -> 57
      {:corrupted, "}"} -> 1197
      {:corrupted, ">"} -> 25137
    end)
    |> sum()
  end

  def bonus(data) do
    scores = data
    |> map(&check/1)
    |> filter(fn
      {:incomplete, _} -> true
      _ -> false
    end)
    |> map(fn {:incomplete, openers} -> score(openers) end)
    |> sort()

    # Get median
    Enum.at(scores, div(length(scores), 2))
  end
end
